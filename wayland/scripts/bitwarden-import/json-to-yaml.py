# /// script
# requires-python = ">=3.10"
# dependencies = [
#   "pyyaml>=6.0",
# ]
# ///

"""Convert a Bitwarden JSON export into one flat YAML file per login item.

Usage:
    uv run bitwarden-import-json.py <export.json> <key-prefix> [--verify]

Writes ``<key-prefix>.<slug>.yaml`` files to a fresh
``/tmp/bitwarden-export-<YYYYMMDD-HHMMSS>/`` folder, plus an ``import.log``
alongside them. The script never touches ``pass``; importing the generated
files into the password store is a separate manual step.

With ``--verify`` every generated file is re-parsed with PyYAML and compared
against values recomputed from the JSON source.
"""

from __future__ import annotations

import argparse
import json
import logging
import os
import re
import sys
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path

import yaml

LOG_FORMAT = "%(asctime)s %(levelname)s %(message)s"
LOCAL_TZ = timezone(timedelta(hours=-3))
TAB_REPLACEMENT = "    "

logger = logging.getLogger(__name__)


class CounterHandler(logging.Handler):
    """Count log records by level name for the run summary."""

    def __init__(self) -> None:
        super().__init__()
        self.counts: dict[str, int] = {}

    def emit(self, record: logging.LogRecord) -> None:
        self.counts[record.levelname] = self.counts.get(record.levelname, 0) + 1


counter = CounterHandler()


@dataclass
class ConvertedItem:
    """A converted login item with the file name it was written to."""

    item_name: str
    filename: str
    mapping: dict[str, str]
    renamed: bool


def parse_args() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="Convert a Bitwarden JSON export to flat YAML files."
    )
    parser.add_argument(
        "export", type=Path, help="path to the Bitwarden JSON export file"
    )
    parser.add_argument("prefix", help="key prefix for the generated file names")
    parser.add_argument(
        "--verify",
        action="store_true",
        help="re-parse every generated file and compare it against the JSON source",
    )
    return parser.parse_args()


def slugify(name: str) -> str:
    """Lowercase ``name`` and replace every non a-z0-9 run with one hyphen."""
    return re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")


def to_local(timestamp: str) -> str:
    """Convert an ISO 8601 ``Z`` timestamp to local UTC-3 ``YYYY-MM-DD HH:MM:SS``."""
    parsed = datetime.fromisoformat(timestamp.replace("Z", "+00:00"))  # noqa: FURB162 (needed on 3.10)
    return parsed.astimezone(LOCAL_TZ).strftime("%Y-%m-%d %H:%M:%S")


def sanitize_multiline(value: str, label: str, item_name: str) -> str:
    """Replace tabs with four spaces so the YAML literal block stays valid."""
    if "\t" in value:
        logger.warning(
            "item '%s': tab(s) in %s converted to 4 spaces", item_name, label
        )
        value = value.replace("\t", TAB_REPLACEMENT)
    return value


def build_mapping(item: dict, item_name: str) -> dict[str, str]:
    """Build the ordered flat mapping for one login item, omitting absent keys."""
    login = item.get("login") or {}
    mapping: dict[str, str] = {}
    password = login.get("password")
    if password is not None:
        mapping["password"] = str(password)
    username = login.get("username")
    if username is not None:
        mapping["username"] = str(username)
    mapping["name"] = item_name
    uris = login.get("uris") or []
    mapping["uri"] = str(uris[0].get("uri", "")) if uris else ""
    if len(uris) > 1:
        logger.warning("item '%s': dropped %d extra uri(s)", item_name, len(uris) - 1)
    notes = item.get("notes")
    if notes:
        mapping["notes"] = sanitize_multiline(str(notes), "notes", item_name)
    history = [
        f"{to_local(entry['lastUsedDate'])}={entry.get('password', '')}"
        for entry in item.get("passwordHistory") or []
        if entry.get("lastUsedDate")
    ]
    if history:
        mapping["password_history"] = sanitize_multiline(
            "\n".join(history), "password_history", item_name
        )
    creation = item.get("creationDate")
    if creation:
        mapping["creation_date"] = to_local(creation)
    revision = item.get("revisionDate")
    if revision:
        mapping["revision_date"] = to_local(revision)
    return mapping


def render_block(key: str, value: str) -> list[str]:
    """Render ``value`` as a literal block scalar that re-parses byte-exact.

    ``|-`` for values with no trailing newline, ``|`` for one, ``|+`` for more.
    """
    content = value.split("\n")
    indicator = "|-"
    if value.endswith("\n"):
        trailing = len(value) - len(value.rstrip("\n"))
        indicator = "|" if trailing == 1 else "|+"
        content = content[:-1]
    return [f"{key}: {indicator}", *(f"  {line}" if line else "" for line in content)]


def render_yaml(mapping: dict[str, str]) -> str:
    """Render the flat mapping as YAML with exact line-break round-tripping."""
    lines: list[str] = []
    for key, value in mapping.items():
        if "\n" in value:
            lines.extend(render_block(key, value))
        else:
            lines.append(f"{key}: {json.dumps(value, ensure_ascii=False)}")
    return "\n".join(lines) + "\n"


def process_item(item: dict, prefix: str, slug_counts: dict[str, int]) -> ConvertedItem:
    """Convert one Bitwarden item and decide its output file name."""
    item_name = str(item.get("name") or "")
    if item.get("type") != 1:
        raise ValueError(f"type {item.get('type')} is not a login (1), item skipped")
    slug = slugify(item_name)
    if not slug:
        raise ValueError("name is empty or slugifies to nothing, item skipped")
    slug_counts[slug] = slug_counts.get(slug, 0) + 1
    filename = f"{prefix}.{slug}.yaml"
    renamed = False
    if slug_counts[slug] > 1:
        filename = f"{prefix}.{slug}.{slug_counts[slug]:03d}.yaml"
        renamed = True
    return ConvertedItem(item_name, filename, build_mapping(item, item_name), renamed)


def load_export(path: Path) -> dict | None:
    """Read and parse the Bitwarden JSON export."""
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        logger.error("failed to read %s: %s", path, exc)
        return None
    if not isinstance(data, dict) or data.get("encrypted"):
        logger.error("%s: unsupported export (encrypted or unexpected structure)", path)
        return None
    return data


def verify_files(output_dir: Path, converted: list[ConvertedItem]) -> bool:
    """Re-parse every generated file and compare it against the expected mapping."""
    ok = True
    for entry in converted:
        parsed = yaml.safe_load(
            (output_dir / entry.filename).read_text(encoding="utf-8")
        )
        mapping = parsed if isinstance(parsed, dict) else {}
        if mapping != entry.mapping:
            ok = False
            logger.error("verify FAILED: %s", entry.filename)
            for key in sorted(set(mapping) | set(entry.mapping)):
                if mapping.get(key) != entry.mapping.get(key):
                    logger.error(
                        "verify mismatch in %s: key '%s' differs", entry.filename, key
                    )
        else:
            logger.info("verify OK: %s", entry.filename)
    return ok


def run(args: argparse.Namespace) -> int:
    """Run the conversion; return the process exit code."""
    formatter = logging.Formatter(LOG_FORMAT)
    logger.setLevel(logging.INFO)
    stream_handler = logging.StreamHandler(sys.stdout)
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)
    logger.addHandler(counter)

    data = load_export(args.export)
    if data is None:
        return 1
    output_dir = Path(
        f"/tmp/bitwarden-export-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
    )
    if output_dir.exists():
        logger.error("output folder %s already exists", output_dir)
        return 1
    output_dir.mkdir(mode=0o700)
    file_handler = logging.FileHandler(output_dir / "import.log", encoding="utf-8")
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    os.chmod(output_dir / "import.log", 0o600)

    items = data.get("items") or []
    if not isinstance(items, list):
        logger.error("export has no item list")
        return 1
    slug_counts: dict[str, int] = {}
    converted: list[ConvertedItem] = []
    for item in items:
        try:
            converted_item = process_item(item, args.prefix, slug_counts)
        except (KeyError, TypeError, ValueError) as exc:
            logger.error("item '%s': %s", item.get("name"), exc)
            continue
        target = output_dir / converted_item.filename
        try:
            target.write_text(render_yaml(converted_item.mapping), encoding="utf-8")
            os.chmod(target, 0o600)
        except OSError as exc:
            logger.error(
                "item '%s': failed to write %s: %s",
                converted_item.item_name,
                target,
                exc,
            )
            continue
        converted.append(converted_item)
        logger.info(
            "item '%s' -> %s", converted_item.item_name, converted_item.filename
        )

    failed = len(items) - len(converted)
    renamed = sum(entry.renamed for entry in converted)
    exit_code = 1 if failed else 0
    verified = True
    if args.verify:
        verified = verify_files(output_dir, converted) and bool(converted)
        if not verified:
            exit_code = 1
    logger.info("--- run summary ---")
    logger.info("items read: %d", len(items))
    logger.info("files written: %d", len(converted))
    logger.info("collisions renamed: %d", renamed)
    logger.info("items failed: %d", failed)
    logger.info("errors: %d", counter.counts.get("ERROR", 0))
    logger.info("warnings: %d", counter.counts.get("WARNING", 0))
    if args.verify:
        logger.info(
            "verify: %s",
            "all files match the JSON source" if verified else "MISMATCHES FOUND",
        )
    logger.info("output folder: %s", output_dir)
    return exit_code


if __name__ == "__main__":
    sys.exit(run(parse_args()))
