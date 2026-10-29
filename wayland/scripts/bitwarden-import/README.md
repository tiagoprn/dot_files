# bitwarden-import

## WHAT

`json-to-yaml.py` converts a Bitwarden JSON export into one flat YAML file per
login item. It only reads the export and writes YAML files plus a log. It never
runs `pass` and never modifies the password store.

## WHY

The passwords live in Bitwarden and must end up in `pass`, one key per item.
Doing that migration by hand invites copy errors and loses data. This script is
the middle step: it turns the export into a predictable, diffable format that
can be reviewed before anything enters the password store. A flat YAML file per
item keeps every field greppable, and the literal block style preserves the
original line breaks of the `notes` field exactly as they appear in the JSON.

## HOW

Run it with `uv` (PyYAML is declared in the PEP 723 header and installed
automatically):

```bash
uv run wayland/scripts/bitwarden-import/json-to-yaml.py <export.json> <key-prefix> [--verify]
```

Real example:

```bash
uv run wayland/scripts/bitwarden-import/json-to-yaml.py \
  wayland/scripts/bitwarden-import/sample.json _sample_ --verify
```

Arguments:

| Argument | Meaning |
|---|---|
| `export` | path to the Bitwarden JSON export (unencrypted) |
| `prefix` | key prefix for the file names, for example `_sample_` |
| `--verify` | re-parse every generated file with PyYAML and compare it against the JSON source |

### Output

A fresh folder per run:

```
/tmp/bitwarden-export-<YYYYMMDD-HHMMSS>/
├── import.log
├── _sample_.linode-batata.yaml
├── _sample_.login-manning-com.yaml
├── _sample_.login-manning-com.002.yaml
└── ... one file per item
```

The folder is created with mode `0700`, the files with mode `0600`. `/tmp` is
`tmpfs` on this machine, so the output vanishes on reboot and is swept after
10 days. The original JSON export is the durable copy.

### YAML schema

Keys appear in this exact order:

```yaml
password: "..."            # omitted when the item has no password
username: "..."            # omitted when the item has no username
name: "linode batata"
uri: "https://..."          # first uris[0].uri, "" when the item has none
notes: |-                   # literal block, every JSON line break preserved
  line 1
  line 2
password_history: |-        # omitted when empty, one entry per line
  2025-08-21 19:37:33=oldpassword
creation_date: "2023-02-14 05:39:00"
revision_date: "2026-04-01 14:32:27"
```

Dropped keys: `id`, `type`, `favorite`, `reprompt`, `folder`, `fields`,
`fido2Credentials`.

### Conversion rules

- **File names**: `<prefix>.<slug>.yaml` where the slug is the item `name`
  lowercased, every non `a-z0-9` run replaced by one hyphen, edges stripped.
  Duplicate slugs get `.002`, `.003` suffixes.
- **Dates**: every ISO 8601 `Z` timestamp is converted to local time (UTC-3)
  and formatted `YYYY-MM-DD HH:MM:SS`, including `password_history` lines.
- **Scalars** are rendered with `json.dumps`, which is valid quoted YAML and
  escapes quotes and backslashes safely.
- **Multiline values** (`notes`, `password_history`) use literal block scalars:
  `|-` when the value has no trailing newline, `|` for one, `|+` for more, so
  every value re-parses byte-for-byte. Tabs are replaced by four spaces and
  logged as `WARNING`, because tabs are invalid inside YAML indentation.
- **Extra URIs** beyond `uris[0]` are dropped and logged as `WARNING`.

### Logging

One `import.log` inside the output folder, also echoed to stdout, format
`%(asctime)s %(levelname)s %(message)s`, levels `INFO`, `WARNING`, `ERROR`.
One `INFO` line per converted item, plus a run summary: items read, files
written, collisions renamed, items failed, errors, warnings, verify result and
the output folder. Passwords never appear in the log.

### Exit codes

| Code | Meaning |
|---|---|
| `0` | every item converted (and `--verify` matched, when requested) |
| `1` | input unreadable or encrypted, output folder already exists, some item failed, or `--verify` found a mismatch |

Item level failures (non-login `type`, empty `name`, unwritable file) log
`ERROR`, skip the item, and let the run continue.

### Verification

`--verify` re-reads each generated file with PyYAML and compares all eight
fields against values recomputed from the JSON. Any difference logs `ERROR`
with the mismatching keys and the run exits `1`.

### Not in scope

Importing the YAML files into `pass` (for example under
`~/.password-store/BTWRDN-IMPORTED/`) is a separate, manual step.