# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Positional, one-key switching between tmux sessions.

WHAT
    A plain-text list of tmux session names, one per line. Line 1 answers
    Ctrl+F1, line 2 answers Ctrl+F2, up to line 11 answering Ctrl+F11.
    Ctrl+F12 always answers the last entry in the list.

WHY
    Reaching a session otherwise costs the session-switcher key plus a fuzzy
    filter and a lookup. Harpoon solves the same problem for files inside nvim
    with a positional list; this is the tmux half of that idea.

HOW
    `uv run harpoon.py <subcommand>`. The file is re-read on every keypress, so
    reordering it in an editor is the only synchronisation step. Subcommands:
    jump, pin, edit, list, path, setup.
"""

from __future__ import annotations

import argparse
import os
import shlex
import subprocess
from dataclasses import dataclass
from pathlib import Path

PIN_COUNT = 11
LAST_KEY = "Ctrl+F12"

HEADER = """\
# tmux session pins, one session name per line.
# a session name here is the same string `tmux ls` prints.
#
# line  1 -> Ctrl+F1     line  7 -> Ctrl+F7
# line  2 -> Ctrl+F2     line  8 -> Ctrl+F8
# line  3 -> Ctrl+F3     line  9 -> Ctrl+F9
# line  4 -> Ctrl+F4     line 10 -> Ctrl+F10
# line  5 -> Ctrl+F5     line 11 -> Ctrl+F11
# line  6 -> Ctrl+F6     Ctrl+F12 -> the last entry
#
# blank lines and lines starting with # are ignored.
"""


def state_path(override: str | None = None) -> Path:
    """Pins file location, honouring XDG_STATE_HOME and an explicit override."""
    if override:
        return Path(override).expanduser()
    base = os.environ.get("XDG_STATE_HOME")
    root = Path(base) if base else Path.home() / ".local" / "state"
    return root / "tmux-harpoon" / "pins.txt"


def read_pins(path: Path) -> list[str]:
    """Session names in slot order. Blank lines and # comments are skipped."""
    try:
        raw = path.read_text(encoding="utf-8")
    except FileNotFoundError:
        return []
    pins = []
    for line in raw.splitlines():
        entry = line.strip()
        if entry and not entry.startswith("#"):
            pins.append(entry)
    return pins


def ensure_file(path: Path) -> None:
    """Create the pins file and its parent directory. Never overwrites."""
    if path.exists():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(HEADER, encoding="utf-8")


def key_for(slot: int) -> str:
    """Key that reaches a 1-based slot, or 'no key' past the bound range."""
    return f"Ctrl+F{slot}" if 1 <= slot <= PIN_COUNT else "no key"


@dataclass(frozen=True)
class Session:
    """One row of `tmux list-sessions`, reduced to what seeding needs."""

    name: str
    attached: bool
    last_attached: int
    created: int


def parse_sessions(output: str) -> list[Session]:
    """Parse name|attached|last_attached|created rows. Bad rows are dropped."""
    sessions = []
    for line in output.splitlines():
        fields = line.strip().split("|")
        if len(fields) != 4:
            continue
        name, attached, last, created = fields
        if not name:
            continue
        sessions.append(
            Session(
                name=name,
                attached=attached not in ("", "0"),
                last_attached=int(last) if last.isdigit() else 0,
                created=int(created) if created.isdigit() else 0,
            )
        )
    return sessions


def seed_order(sessions: list[Session]) -> list[str]:
    """Session names, most worth a low slot first.

    Attached sessions lead, then the most recently attached, then the newest,
    then alphabetical so the result is stable between runs.
    """
    ordered = sorted(
        sessions,
        key=lambda s: (not s.attached, -s.last_attached, -s.created, s.name),
    )
    return [session.name for session in ordered]


SESSION_FORMAT = (
    "#{session_name}|#{session_attached}|#{session_last_attached}|#{session_created}"
)


class TmuxError(RuntimeError):
    """A tmux command exited non-zero."""


def tmux(*args: str) -> str:
    """Run one tmux command and return its stdout."""
    result = subprocess.run(
        ["tmux", *args], capture_output=True, text=True, check=False
    )
    if result.returncode != 0:
        raise TmuxError(result.stderr.strip() or "tmux failed")
    return result.stdout


def live_sessions() -> list[Session]:
    """Every session on the tmux server this process talks to."""
    return parse_sessions(tmux("list-sessions", "-F", SESSION_FORMAT))


def live_names() -> list[str]:
    """Session names, or none when no server is running."""
    try:
        return [session.name for session in live_sessions()]
    except TmuxError:
        return []


def current_session() -> str:
    """Name of the session the calling client is attached to."""
    return tmux("display-message", "-p", "#{session_name}").strip()


def notify(message: str) -> None:
    """Show a message in the status line, or on stdout outside tmux."""
    if os.environ.get("TMUX"):
        subprocess.run(["tmux", "display-message", "-d", "3000", message], check=False)
    else:
        print(message)


def resolve_jump(pins: list[str], which: str) -> tuple[str | None, str]:
    """Session to switch to, plus the message to show when there is none."""
    if not pins:
        return None, "no pins yet, open the list to seed it"
    if which != "last" and not which.isdigit():
        return None, f"not a slot: {which}"
    if which == "last":
        return pins[-1], ""
    slot = int(which)
    if not 1 <= slot <= len(pins):
        return None, f"no pin at line {slot}"
    return pins[slot - 1], ""


def pin_entry(pins: list[str], session: str) -> tuple[list[str], bool, str]:
    """Updated pins, whether the file must grow, and the message to show."""
    if session in pins:
        slot = pins.index(session) + 1
        return pins, False, f"already at line {slot}, {key_for(slot)}"
    updated = [*pins, session]
    slot = len(updated)
    return updated, True, f"pinned {session} as {slot} ({key_for(slot)})"


def seed_entries(pins: list[str], live: list[str]) -> tuple[list[str], bool]:
    """Seed from live sessions only when the list has no entries at all."""
    if pins or not live:
        return pins, False
    return list(live), True


def append_pins(path: Path, names: list[str]) -> None:
    """Append names one per line, keeping every line already in the file."""
    with path.open("a", encoding="utf-8") as handle:
        handle.write("".join(f"{name}\n" for name in names))


def cmd_jump(args: argparse.Namespace) -> int:
    pins = read_pins(state_path(args.file))
    session, message = resolve_jump(pins, args.slot)
    if session is None:
        notify(message)
        return 0
    if session not in live_names():
        notify(f"pin {args.slot}: {session} no longer exists")
        return 0
    try:
        tmux("switch-client", "-t", session)
    except TmuxError as error:
        notify(f"cannot switch to {session}: {error}")
        return 1
    return 0


def cmd_pin(args: argparse.Namespace) -> int:
    path = state_path(args.file)
    ensure_file(path)
    pins = read_pins(path)
    session = args.session or current_session()
    _, grows, message = pin_entry(pins, session)
    if grows:
        append_pins(path, [session])
    notify(message)
    return 0


def cmd_edit(args: argparse.Namespace) -> int:
    path = state_path(args.file)
    ensure_file(path)
    pins = read_pins(path)
    if not pins:
        seeds = seed_order(live_sessions())
        _, seeded = seed_entries(pins, seeds)
        if seeded:
            append_pins(path, seeds)
            notify(f"seeded {len(seeds)} live sessions")
    editor = shlex.join(["nvim", "+set autowriteall", "+set number", str(path)])
    try:
        tmux("display-popup", "-E", "-w", "80%", "-h", "70%", editor)
    except TmuxError as error:
        notify(f"cannot open the editor: {error}")
        return 1
    return 0


def cmd_path(args: argparse.Namespace) -> int:
    """Print the pins file path. Creates nothing, reads nothing."""
    print(state_path(args.file))
    return 0


def cmd_list(args: argparse.Namespace) -> int:
    path = state_path(args.file)
    pins = read_pins(path)
    if not pins:
        print("no pins yet")
        return 0
    live = set(live_names())
    for slot, name in enumerate(pins, start=1):
        gone = "" if not live or name in live else "  (gone)"
        print(f"{slot:>2}  {key_for(slot):<9} {name}{gone}")
    return 0


def cmd_setup(args: argparse.Namespace) -> int:
    path = state_path(args.file)
    ensure_file(path)
    pins = read_pins(path)
    if not pins:
        seeds = seed_order(live_sessions())
        if seeds:
            append_pins(path, seeds)
            print(f"seeded {len(seeds)} live sessions")
    print(f"pins file: {path}")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="harpoon.py", description="Positional, one-key tmux session pins."
    )
    parser.add_argument("--file", help="pins file, defaults to the XDG state path")
    subcommands = parser.add_subparsers(dest="command", required=True)

    jump = subcommands.add_parser("jump", help="switch to a pinned session")
    jump.add_argument("slot", help="1-based line number, or 'last'")
    jump.set_defaults(func=cmd_jump)

    pin = subcommands.add_parser("pin", help="append a session if absent")
    pin.add_argument("--session", help="session to pin, default is the current one")
    pin.set_defaults(func=cmd_pin)

    edit = subcommands.add_parser("edit", help="open the list in nvim")
    edit.set_defaults(func=cmd_edit)

    listing = subcommands.add_parser("list", help="print the pins")
    listing.set_defaults(func=cmd_list)

    where = subcommands.add_parser("path", help="print the pins file path")
    where.set_defaults(func=cmd_path)

    setup = subcommands.add_parser("setup", help="create and seed the pins file")
    setup.set_defaults(func=cmd_setup)

    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
