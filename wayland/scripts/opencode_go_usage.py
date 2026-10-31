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
7. Store it as the first line of the pass entry named by `PASS_ENTRY` below,
   or export it as `OPENCODE_API_KEY`. If both exist the environment variable
   is tried first and the script falls back to pass after an HTTP 401.

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


class AuthError(RuntimeError):
    """Raised when the API rejects the credential with HTTP 401."""


def read_pass_entry() -> str | None:
    """Read the key stored in the pass entry used by this script.

    Returns:
        The first line of the entry, or None when pass is unavailable or the
        entry is empty.
    """
    try:
        result = subprocess.run(
            ["pass", "show", PASS_ENTRY],
            capture_output=True,
            text=True,
            timeout=15,
            check=True,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    lines = result.stdout.splitlines()
    return lines[0].strip() if lines else None


def candidate_keys() -> list[str]:
    """Return the key sources to try, environment first, then pass.

    Returns:
        Non-empty list of distinct keys.

    Raises:
        SystemExit: When no source yields a key.
    """
    keys: list[str] = []
    env_key = os.environ.get("OPENCODE_API_KEY", "").strip()
    if env_key:
        keys.append(env_key)
    stored_key = read_pass_entry()
    if stored_key and stored_key not in keys:
        keys.append(stored_key)
    if not keys:
        raise SystemExit(f"Set OPENCODE_API_KEY or store a key in the pass entry {PASS_ENTRY}")
    return keys


def fetch_status(api_key: str) -> dict[str, Any]:
    """Fetch the Go subscription status from the Console API.

    Args:
        api_key: Console personal API key.

    Returns:
        The decoded JSON body of `GET /api/go/status`.

    Raises:
        AuthError: When the API answers HTTP 401 for this credential.
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
        raise SystemExit(f"GET /api/go/status failed: HTTP {exc.code} {detail}") from exc
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


def main() -> None:
    """Fetch Go usage and print it, or print the raw payload with `--json`."""
    parser = argparse.ArgumentParser(description="Show OpenCode Go plan usage.")
    parser.add_argument(
        "--json",
        action="store_true",
        help="print the raw /api/go/status payload instead of the summary",
    )
    args = parser.parse_args()

    keys = candidate_keys()
    status: dict[str, Any] | None = None
    last_error: AuthError | None = None
    for position, key in enumerate(keys, start=1):
        try:
            status = fetch_status(key)
        except AuthError as exc:
            last_error = exc
            if position < len(keys):
                print("key source rejected, trying the next one", file=sys.stderr)
            continue
        break
    if status is None:
        raise SystemExit(f"No working API key: {last_error}")
    if args.json:
        print(json.dumps(status, indent=2))
        return
    print(render(status, datetime.now(UTC)))


if __name__ == "__main__":
    main()
