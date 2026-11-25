# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///

"""Print OpenCode Go plan usage exactly as the Console Go page shows it.

Reads the Go subscription meters (5-hour, weekly, monthly) from the OpenCode
Console API with a read-only personal API key.

How to create an API key that works as intended
------------------------------------------------
1. Sign in to https://opencode.ai/console.
2. Open **Account**, then **Personal API keys**, then **Add API key**.
3. Pick the workspace that owns the Go plan. It is the `wrk_...` id in the
   console URL, for example `wrk_01KYSAVEQB5DQW7NTCFWR53VXW`.
4. Set **Permissions** to **Read only**. That level is the one verified to
   answer `GET /api/go/status`, which is the only API this script calls.
   A key limited to model calling returns HTTP 403 for it.
5. Set **Expiration** (30 days is a good default) and click **Create**.
6. Copy the key right away. It starts with `oc_sk_`, is 51 characters, and is
   shown only once. Later the console only displays its prefix.
7. Store it as the first line of the pass entry named by `PASS_ENTRY` below, or
   name a different entry at run time with `--pass-entry`. That entry is the
   only key source: the script never reads the environment.

Do not use browser credentials
------------------------------
Never point this script at a browser session cookie, a session token, an OAuth
or device-flow token, or anything copied out of the browser. Those credentials
act as your whole account: they can buy credits, change the subscription, and
cancel the plan. The OAuth `scope` parameter does not help either, because the
server does not enforce it. This was verified: a token requested with
`scope=usage:read billing:read` could still read `/api/members`, a route that
needs `members:read`. Only a personal API key set to **Read only** is
acceptable here, so the script can never alter billing or the subscription.

The request must also send a `User-Agent` header. Without one, Cloudflare
answers HTTP 403 with error 1010 ("browser's signature"), which is why the
script sets its own.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from datetime import UTC, datetime, timedelta
from pathlib import Path
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

API_BASE = "https://console.opencode.ai"
PASS_ENTRY = "api-keys/opencode_google_auth_prngolti_read_only"
METER_ORDER: tuple[tuple[str, str], ...] = (
    ("fiveHour", "5-hour window"),
    ("week", "Weekly"),
    ("month", "Monthly"),
)
TEXT_COLUMN = 38
FIVE_HOUR_WINDOW = timedelta(hours=5)
BLUE_COLOR = "#89b4fa"
YELLOW_COLOR = "#f9e2af"
RED_COLOR = "#f38ba8"
WIDGET_LABELS: dict[str, str] = {"fiveHour": "5h", "week": "W", "month": "M"}


class AuthError(RuntimeError):
    """Raised when the API rejects the credential with HTTP 401."""


class ForbiddenError(RuntimeError):
    """Raised when the key is valid but not allowed to read the Go status.

    A personal API key that may call models but is not set to **Read only**
    gets HTTP 403 here. The cache script treats that as "skip this key" rather
    than a failure, because the same answer comes back on every retry.
    """


def read_pass_entry(pass_entry: str) -> str:
    """Read the key from the given pass entry.

    Args:
        pass_entry: Path of the `pass` entry that holds the API key.

    Returns:
        The first line of the entry, stripped.

    Raises:
        SystemExit: When pass is unavailable, the entry is missing, or it is
            empty.
    """
    try:
        result = subprocess.run(
            ["pass", "show", pass_entry],
            capture_output=True,
            text=True,
            timeout=15,
            check=True,
        )
    except (OSError, subprocess.SubprocessError) as exc:
        raise SystemExit(
            f"Cannot read the key from `pass show {pass_entry}`: {exc}"
        ) from exc
    lines = result.stdout.splitlines()
    key = lines[0].strip() if lines else ""
    if not key:
        raise SystemExit(f"The pass entry {pass_entry} holds no key")
    return key


def fetch_status(api_key: str) -> dict[str, Any]:
    """Fetch the Go subscription status from the Console API.

    Args:
        api_key: Console personal API key.

    Returns:
        The decoded JSON body of `GET /api/go/status`.

    Raises:
        AuthError: When the API answers HTTP 401 for this credential.
        ForbiddenError: When the API answers HTTP 403 for this credential.
        SystemExit: On transport failure or any other non-200 response.
    """
    request = Request(
        f"{API_BASE}/api/go/status",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Accept": "application/json",
            "User-Agent": "opencode-go-usage/1.0",
        },
    )
    try:
        with urlopen(request, timeout=20) as response:
            body = response.read().decode()
    except HTTPError as exc:
        detail = exc.read().decode(errors="replace")[:300]
        if exc.code == 401:
            raise AuthError(f"HTTP 401 {detail}") from exc
        if exc.code == 403:
            raise ForbiddenError(f"HTTP 403 {detail}") from exc
        raise SystemExit(
            f"GET /api/go/status failed: HTTP {exc.code} {detail}"
        ) from exc
    except URLError as exc:
        raise SystemExit(f"GET /api/go/status failed: {exc.reason}") from exc
    data = json.loads(body)
    if not isinstance(data, dict):
        raise SystemExit(f"Unexpected response type: {type(data).__name__}")
    return data


def parse_time(value: str | None) -> datetime | None:
    """Parse an ISO-8601 timestamp that ends in `Z`.

    Args:
        value: Timestamp such as `2026-11-02T00:00:00.000Z`, or None.

    Returns:
        Timezone-aware UTC datetime, or None when the input is missing.
    """
    if not value:
        return None
    return datetime.fromisoformat(value.replace("Z", "+00:00")).astimezone(UTC)


def countdown(target: datetime | None, now: datetime) -> str | None:
    """Format a floor-rounded countdown in the Console style, for example `1d 13h`.

    Args:
        target: Moment being counted down to.
        now: Current time.

    Returns:
        Countdown text, or None when the target is missing or already passed.
    """
    if target is None:
        return None
    remaining = int((target - now).total_seconds())
    if remaining <= 0:
        return None
    days, rest = divmod(remaining, 86400)
    hours, rest = divmod(rest, 3600)
    minutes = rest // 60
    if days:
        return f"{days}d {hours}h"
    if hours:
        return f"{hours}h {minutes}m"
    return f"{minutes}m"


def percent_used(meter: dict[str, Any]) -> int:
    """Return used capacity as a whole percent, rounded half up like the Console.

    Args:
        meter: A meter holding `limitMicroCents` and `usedMicroCents`.

    Returns:
        Percent between 0 and 100, or 0 when the meter has no limit.
    """
    limit = int(meter.get("limitMicroCents") or 0)
    used = int(meter.get("usedMicroCents") or 0)
    if limit <= 0:
        return 0
    return min(100, int(used * 100 / limit + 0.5))


def reset_time(meter: dict[str, Any], key: str) -> datetime | None:
    """Return when a meter resets, deriving the 5-hour window when needed.

    The 5-hour window runs for five hours from the first request, so the
    server can report `startsAt` without `resetsAt`. Week and month windows
    always carry their own `resetsAt`, so only the 5-hour meter is derived.

    Args:
        meter: A meter holding `startsAt` and `resetsAt`.
        key: Meter key, one of `fiveHour`, `week`, `month`.

    Returns:
        Reset moment, or None while no window is open.
    """
    resets_at = parse_time(meter.get("resetsAt"))
    if resets_at is not None:
        return resets_at
    starts_at = parse_time(meter.get("startsAt"))
    if key == "fiveHour" and starts_at is not None:
        return starts_at + FIVE_HOUR_WINDOW
    return None


def render(status: dict[str, Any], now: datetime) -> str:
    """Render the Go page summary as plain text.

    Args:
        status: Payload from `GET /api/go/status`.
        now: Current time, used for every countdown.

    Returns:
        Multi-line summary, or a single notice line without an active plan.
    """
    access = status.get("access")
    if not isinstance(access, dict):
        return "No active Go subscription."

    header = "Go Subscription"
    renews = countdown(parse_time(access.get("endsAt")), now)
    if renews:
        header = f"{header:<{TEXT_COLUMN}}Renews in {renews}"

    lines = [header]
    meters = access.get("meters")
    meters = meters if isinstance(meters, dict) else {}
    for key, label in METER_ORDER:
        meter = meters.get(key)
        if not isinstance(meter, dict):
            continue
        line = f"  {label:<15}{percent_used(meter):>3}% used"
        resets = countdown(reset_time(meter, key), now)
        if resets:
            line = f"{line:<{TEXT_COLUMN}}Resets in {resets}"
        elif key == "fiveHour":
            line = f"{line:<{TEXT_COLUMN}}no request was made today yet"
        lines.append(line)
    return "\n".join(lines)


def color_for(percent: int) -> str:
    """Pick a span color from one meter's own usage percent.

    Args:
        percent: Percent used of that meter.

    Returns:
        Blue below 51, yellow from 51 to 90, red from 91 upward.
    """
    if percent >= 91:
        return RED_COLOR
    if percent >= 51:
        return YELLOW_COLOR
    return BLUE_COLOR


def state_class(percents: list[int]) -> str:
    """Classify overall usage so waybar CSS can color the module.

    Args:
        percents: Percent used of every meter.

    Returns:
        `idle` when nothing is used, then `ok`, `warn` or `crit` by highest.
    """
    highest = max(percents, default=0)
    if highest == 0:
        return "idle"
    if highest >= 91:
        return "crit"
    if highest >= 51:
        return "warn"
    return "ok"


def render_widget(status: dict[str, Any], now: datetime) -> dict[str, Any]:
    """Build the waybar payload for `return-type: json`.

    Args:
        status: Payload from `GET /api/go/status`.
        now: Current time, used for every countdown.

    Returns:
        Keys `text` with one colored span per window, `class` for CSS state,
        `tooltip` holding the plain summary lines, and `fetchedAt`, the epoch
        milliseconds of this fetch so a reader can show the data's age.
    """
    access = status.get("access")
    if not isinstance(access, dict):
        return {
            "text": "Opencode Go: n/a",
            "class": "idle",
            "tooltip": "No active Go subscription.",
            "fetchedAt": int(now.timestamp() * 1000),
        }
    meters = access.get("meters")
    meters = meters if isinstance(meters, dict) else {}

    spans: list[str] = []
    percents: list[int] = []
    for key, label in METER_ORDER:
        meter = meters.get(key)
        meter = meter if isinstance(meter, dict) else {}
        percent = percent_used(meter)
        percents.append(percent)
        closed = key == "fiveHour" and reset_time(meter, key) is None
        value = "-" if closed else f"{percent}%"
        spans.append(
            f'<span foreground="{color_for(percent)}">{WIDGET_LABELS[key]} {value}</span>'
        )

    return {
        "text": f"| {' | '.join(spans)} |",
        "class": state_class(percents),
        "tooltip": render(status, now),
        "fetchedAt": int(now.timestamp() * 1000),
    }


def write_cache(path: str, payload: dict[str, Any]) -> None:
    """Write the widget payload to `path` atomically, readable by its owner only.

    A temporary file plus `os.replace` means a reader watching the file never
    sees a half-written payload.

    Args:
        path: Destination file.
        payload: Value returned by `render_widget`.
    """
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    tmp = target.with_name(target.name + ".tmp")
    tmp.write_text(json.dumps(payload) + "\n")
    tmp.chmod(0o600)
    os.replace(tmp, target)


def main() -> None:
    """Fetch Go usage and print the summary, or waybar JSON with `--widget`.

    With `--cache-file` the waybar JSON is written to that file instead of
    being printed, so a quickshell widget can read it without waiting.
    """
    parser = argparse.ArgumentParser(description="Show OpenCode Go plan usage.")
    parser.add_argument(
        "--widget",
        action="store_true",
        help="print waybar JSON with one colored span per usage window",
    )
    parser.add_argument(
        "--pass-entry",
        default=PASS_ENTRY,
        help="pass entry that holds the API key (default: %(default)s)",
    )
    parser.add_argument(
        "--cache-file",
        default="",
        help="write the widget JSON to this file atomically instead of printing",
    )
    args = parser.parse_args()

    try:
        status = fetch_status(read_pass_entry(args.pass_entry))
    except AuthError as exc:
        raise SystemExit(
            f"The pass entry {args.pass_entry} was rejected: {exc}"
        ) from exc
    except ForbiddenError as exc:
        print(
            f"The pass entry {args.pass_entry} cannot read the Go status: {exc}",
            file=sys.stderr,
        )
        raise SystemExit(3) from exc
    if args.widget:
        payload = render_widget(status, datetime.now(UTC))
        if args.cache_file:
            write_cache(args.cache_file, payload)
            return
        print(json.dumps(payload))
        return
    print(render(status, datetime.now(UTC)))


if __name__ == "__main__":
    main()
