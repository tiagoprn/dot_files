"""
YOUTUBE WATCH LATER TRIMMER:
Keeps only the N most recently added videos in the Watch Later playlist.
Uses Playwright with a persistent browser profile (no API key required).

REQUIREMENT: install firefox on playwright (if not installed):
  uv run --with playwright playwright install firefox

USAGE:
  Step 1: open my main firefox account, login on youtube, pkill firefox (so sqlite releases the locks on the databases), then:
      uv run youtube_watch_later_cleanup_with_playwright.py --import-cookies

  Step 2: run the trim (add "--visible" to inspect in real-time what is happening if you need do debug):
      uv run youtube_watch_later_cleanup_with_playwright.py --keep 30

Requirements:
  (dependencies are declared inline via PEP 723 — uv handles install automatically)
"""

# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "playwright",
#     "browser-cookie3",
# ]
# ///

import argparse
import json
import re
import time
import sys
from pathlib import Path
from playwright.sync_api import sync_playwright, TimeoutError as PWTimeout

PROFILE_DIR = Path("./yt_profile").resolve()
STORAGE_STATE_FILE = Path("./yt_storage_state.json").resolve()
LOG_FILE = Path("./removal_log.jsonl")
WATCH_LATER_URL = "https://www.youtube.com/playlist?list=WL"

VIDEO_SELECTOR = "ytd-playlist-video-renderer"
MENU_BUTTON_SELECTOR = 'button[aria-label="Action menu"]'


def log_event(event: dict):
    event["ts"] = time.time()
    with LOG_FILE.open("a", encoding="utf-8") as f:
        f.write(json.dumps(event) + "\n")


import browser_cookie3

def import_firefox_cookies():
    """Extracts youtube.com/google.com cookies from your real, logged-in
    Firefox profile and saves them as Playwright storage_state JSON.
    No manual login step needed."""
    import time as _time
    MAX_REASONABLE_EXPIRY = int(_time.time()) + 60 * 60 * 24 * 365 * 10  # 10 years out

    def normalize_expires(raw_expires):
        try:
            val = float(raw_expires)
        except (TypeError, ValueError):
            return -1
        if val <= 0:
            return -1
        val = int(val)
        # Some cookie stores report expiry in ms or with corrupted huge values.
        # If it's absurdly large (e.g. > 10 years from now), treat as session cookie.
        if val > MAX_REASONABLE_EXPIRY:
            return -1
        return val

    def collect(domain_name):
        cj = browser_cookie3.firefox(domain_name=domain_name)
        result = []
        for c in cj:
            if "youtube.com" not in c.domain and "google.com" not in c.domain:
                continue
            result.append({
                "name": str(c.name),
                "value": str(c.value),
                "domain": str(c.domain),
                "path": str(c.path or "/"),
                "expires": normalize_expires(c.expires),
                "httpOnly": bool(getattr(c, "_rest", {}).get("HttpOnly", False)) if hasattr(c, "_rest") else False,
                "secure": bool(c.secure),
                "sameSite": "None" if bool(c.secure) else "Lax",
            })
        return result

    cookies = collect(".youtube.com") + collect(".google.com")
    # de-duplicate by (name, domain, path)
    seen = set()
    deduped = []
    for ck in cookies:
        key = (ck["name"], ck["domain"], ck["path"])
        if key in seen:
            continue
        seen.add(key)
        deduped.append(ck)
    cookies = deduped

    storage_state = {"cookies": cookies, "origins": []}
    STORAGE_STATE_FILE.write_text(json.dumps(storage_state, indent=2))
    print(f"Imported {len(cookies)} cookies from Firefox into {STORAGE_STATE_FILE}")


def sort_by_newest(page):
    page.goto(WATCH_LATER_URL, wait_until="domcontentloaded")
    page.wait_for_timeout(3000)
    try:
        page.wait_for_selector(VIDEO_SELECTOR, timeout=30000)
    except PWTimeout:
        page.screenshot(path="debug_screenshot.png", full_page=True)
        Path("debug_page.html").write_text(page.content())
        log_event({
            "event": "video_selector_not_found",
            "current_url": page.url,
            "page_title": page.title(),
        })
        raise
    page.wait_for_timeout(2000)
    try:
        # The sort dropdown is a tp-yt-paper-button near "Sort by"
        sort_trigger = page.get_by_text("Sort by", exact=False).first
        sort_trigger.click(timeout=5000)
        page.wait_for_timeout(500)
        newest_option = page.get_by_text("Date added (newest)", exact=False).first
        newest_option.click(timeout=5000)
        page.wait_for_timeout(1500)
        log_event({"event": "sort_applied"})
    except PWTimeout:
        log_event({"event": "sort_click_failed", "note": "manual sort may be required - continuing anyway"})


def auto_scroll_load_all(page, max_stable_rounds=3, scroll_pause_ms=1200, max_rounds=2000):
    last_count = -1
    stable = 0
    rounds = 0
    while stable < max_stable_rounds and rounds < max_rounds:
        page.evaluate("window.scrollTo(0, document.documentElement.scrollHeight)")
        page.wait_for_timeout(scroll_pause_ms)
        count = page.locator(VIDEO_SELECTOR).count()
        if count == last_count:
            stable += 1
        else:
            stable = 0
        last_count = count
        rounds += 1
        if rounds % 5 == 0 or stable >= max_stable_rounds:
            log_event({"event": "scroll_progress", "loaded": count})
    return last_count


def remove_excess(page, keep: int, batch_size=50, batch_break_s=0, per_item_delay_ms=0):
    removed = 0
    consecutive_failures = 0

    def dialog_handler(dialog):
        log_event({"event": "dialog_dismissed", "message": dialog.message})
        dialog.accept()

    page.on("dialog", dialog_handler)

    while True:
        items = page.locator(VIDEO_SELECTOR)
        total = items.count()
        if total <= keep:
            log_event({"event": "done", "remaining": total})
            break

        target = items.nth(total - 1)  # oldest, since sorted newest-first
        try:
            target.scroll_into_view_if_needed(timeout=5000)
            target.hover(timeout=3000)
            page.wait_for_timeout(300)

            menu_btn = target.locator(
                'button[aria-label="Action menu"], ytd-menu-renderer button'
            ).last
            menu_btn.click(timeout=5000)
            page.wait_for_timeout(600)

            # Search the whole page for a visible "Remove from" text, regardless of wrapper element,
            # since YouTube's popup container tag/attributes have proven unreliable to predict.
            remove_option = page.locator(
                "ytd-menu-service-item-renderer, tp-yt-paper-item"
            ).locator("visible=true").filter(
                has_text=re.compile("Remove from|Remover de", re.IGNORECASE)
            ).first
            try:
                remove_option.wait_for(state="visible", timeout=3000)
            except PWTimeout:
                page.screenshot(path="debug_menu_screenshot.png", full_page=False)
                Path("debug_menu_page.html").write_text(page.content())
                log_event({"event": "menu_debug_captured", "note": "saved debug_menu_screenshot.png and debug_menu_page.html"})
                raise
            remove_option.click(timeout=5000)

            # Confirm the item actually disappeared before counting as success
            page.wait_for_timeout(per_item_delay_ms)
            new_total = page.locator(VIDEO_SELECTOR).count()
            if new_total >= total:
                raise PWTimeout("Item count did not decrease after removal click")

            removed += 1
            consecutive_failures = 0
            log_event({"event": "removed", "count": removed, "remaining_target": new_total})

        except PWTimeout as e:
            consecutive_failures += 1
            log_event({"event": "removal_failed", "remaining_before": total, "consecutive_failures": consecutive_failures, "error": str(e)})
            page.keyboard.press("Escape")
            page.wait_for_timeout(500)
            if consecutive_failures >= 10:
                log_event({"event": "aborted", "reason": "too many consecutive failures"})
                break

        if removed % batch_size == 0 and removed > 0:
            log_event({"event": "batch_pause", "removed_so_far": removed})
            page.wait_for_timeout(batch_break_s * 1000)

    return removed


def auto_scroll_until(page, min_count, scroll_pause_ms=1200, max_rounds=500):
    count = 0
    rounds = 0
    while count < min_count and rounds < max_rounds:
        page.evaluate("window.scrollTo(0, document.documentElement.scrollHeight)")
        page.wait_for_timeout(scroll_pause_ms)
        count = page.locator(VIDEO_SELECTOR).count()
        rounds += 1
        if rounds % 5 == 0:
            log_event({"event": "scroll_progress", "loaded": count})
    return count


def debug_single_removal(page, index):
    """Attempt removal on exactly one item at `index` (0-based) and report outcome, no loop."""
    items = page.locator(VIDEO_SELECTOR)
    target = items.nth(index)
    target.scroll_into_view_if_needed(timeout=5000)
    target.hover(timeout=3000)
    page.wait_for_timeout(300)

    menu_btn = target.locator(
        'button[aria-label="Action menu"], ytd-menu-renderer button'
    ).last
    menu_btn.click(timeout=5000)
    page.wait_for_timeout(600)
    page.screenshot(path="debug_menu_open.png", full_page=False)

    remove_option = page.locator(
        "ytd-menu-service-item-renderer, tp-yt-paper-item"
    ).locator("visible=true").filter(
        has_text=re.compile("Remove from|Remover de", re.IGNORECASE)
    ).first
    remove_option.wait_for(state="visible", timeout=5000)
    remove_option.click(timeout=5000)
    page.wait_for_timeout(1500)
    page.screenshot(path="debug_after_click.png", full_page=False)

    new_total = page.locator(VIDEO_SELECTOR).count()
    log_event({"event": "debug_single_removal_result", "index": index, "new_total": new_total})
    print(f"Debug removal attempted on index {index}. New item count: {new_total}. Check debug_menu_open.png and debug_after_click.png")


def run_trim(keep: int, headless: bool = True, target_index: int = None):
    if not STORAGE_STATE_FILE.exists():
        print("No imported session found. Run with --import-cookies first.")
        sys.exit(1)

    with sync_playwright() as p:
        browser = p.firefox.launch(headless=headless)
        context = browser.new_context(storage_state=str(STORAGE_STATE_FILE))
        page = context.new_page()
        sort_by_newest(page)

        if target_index is not None:
            auto_scroll_until(page, min_count=target_index + 1)
            debug_single_removal(page, target_index)
            context.close()
            return

        total_loaded = auto_scroll_load_all(page)
        log_event({"event": "scroll_complete", "total_loaded": total_loaded})
        removed = remove_excess(page, keep=keep)
        log_event({"event": "finished", "total_removed": removed})
        print(f"Finished. Removed {removed} videos. Target kept: {keep}.")
        context.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Trim YouTube Watch Later playlist without API key.")
    parser.add_argument("--import-cookies", action="store_true", help="Import session cookies from local Firefox profile.")
    parser.add_argument("--keep", type=int, default=30, help="Number of most recent videos to keep.")
    parser.add_argument("--visible", action="store_true", help="Run non-headless for debugging.")
    parser.add_argument("--target-index", type=int, default=None,
                         help="Debug: only scroll to load at least N items, then attempt removal on item at index N-1 once, then exit.")
    args = parser.parse_args()

    if args.import_cookies:
        import_firefox_cookies()
    else:
        run_trim(keep=args.keep, headless=not args.visible, target_index=args.target_index)
