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

The converter itself never runs `pass` and never touches the password store.
Importing the YAML files is done by `import-to-pass.sh`, documented below.

## The importer: import-to-pass.sh

### WHAT

`import-to-pass.sh` inserts the YAML files produced by `json-to-yaml.py` into
the pass store, one key per file, and then verifies every key against its
source file. It reads the export folder and writes encrypted entries under
`~/.password-store/BTWRDN-IMPORTED/`. It never modifies the YAML files and
never logs passwords.

### WHY

Inserting by hand invites key-name mistakes and proves nothing afterwards.
The script makes the key rule mechanical, refuses to overwrite an entry that
already exists, and decrypts every stored entry again to prove the store
matches the files. Trusting a migration then needs one green summary line
instead of opening every password by eye.

### HOW

Run it with `bash`:

```bash
bash wayland/scripts/bitwarden-import/import-to-pass.sh
```

It asks for the folder where the YAML files were generated, with no default:

```text
YAML folder:
```

Paste the `output folder` path printed by the converter. The folder can also
be passed as the only argument, which skips the prompt:

```bash
bash wayland/scripts/bitwarden-import/import-to-pass.sh /tmp/bitwarden-export-20261029-100557
```

Your `gpg-agent` pinentry asks for the passphrase during the run, once per
agent cache.

#### Key naming

The file name splits on its **first** dot: the first token becomes the folder
inside the store, everything after it becomes the key.

| File | pass key |
|---|---|
| `_sample_.zoom-us.yaml` | `BTWRDN-IMPORTED/_sample_/zoom-us` |
| `_sample_.petlove-site-compras-e-plano-de-sa-de.yaml` | `BTWRDN-IMPORTED/_sample_/petlove-site-compras-e-plano-de-sa-de` |
| `_sample_.login-manning-com.002.yaml` | `BTWRDN-IMPORTED/_sample_/login-manning-com.002` |

A file name without a dot is rejected and counted as a failure. Entries
already in the store are skipped with a `WARN` and never overwritten.

#### Verification

After the import every key is decrypted and compared against its source file.
Trailing newlines are excluded on both sides, so a trailing-newline quirk
can never fake a mismatch; every other byte must match exactly. Results are
reported as `verify MISSING`, `verify UNREADABLE` or `verify MISMATCH`, plus
a final `verify: ok=N mismatches=N` line.

#### Exit codes

| Code | Meaning |
|---|---|
| `0` | every key inserted and verified |
| `1` | folder missing, empty, or no folder given |
| `2` | some insert failed |
| `3` | a stored entry is missing, unreadable, or differs |

## Quick start: generate, then import

Prerequisites, checked once before the first migration:

```bash
pass --version          # pass installed and initialized
gpg --list-secret-keys  # a secret key exists to encrypt with
```

1. Generate the YAML files. The converter prints its `output folder` path:

```bash
cd /storage/src/dot_files
uv run wayland/scripts/bitwarden-import/json-to-yaml.py <export.json> <prefix> --verify
```

2. Import them into pass, pasting that printed folder at the prompt:

```bash
bash wayland/scripts/bitwarden-import/import-to-pass.sh
```

`/tmp` is wiped on reboot: if the output folder is gone, run step 1 again
before importing.

Spot check by hand whenever you want to:

```bash
ls ~/.password-store/BTWRDN-IMPORTED/_sample_/*.gpg | wc -l  # one file per key
diff <(pass show BTWRDN-IMPORTED/_sample_/zoom-us) /tmp/bitwarden-export-20261029-100557/_sample_.zoom-us.yaml
```

Read an entry:

```bash
pass show BTWRDN-IMPORTED/_sample_/zoom-us
pass show BTWRDN-IMPORTED/_sample_/zoom-us | grep '^password:'  # just the secret
```

`pass show -o` returns the first YAML line (`password: "..."`), not a bare
password, which is why the `grep` idiom above is the one to use.

Version the store so the migration stays traceable:

```bash
pass git init                                  # once, if never done
pass git add -A && pass git commit -m "import bitwarden export"
```

After a verified import the `/tmp` output folder is disposable. The durable
copies are the source JSON export and the pass store's own git history.