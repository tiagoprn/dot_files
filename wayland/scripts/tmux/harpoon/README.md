# tmux session pins

Positional, one-key switching between tmux sessions, in the spirit of harpoon.

## WHAT

A plain-text list of tmux session names, one per line. The line number is the
key:

| Line | Key |
| --- | --- |
| 1 to 11 | `Ctrl+F1` to `Ctrl+F11` |
| last line | `Ctrl+F12` |
| any line past 11 | none until you move it up |

The list lives in `$XDG_STATE_HOME/tmux-harpoon/pins.txt`, which resolves to
`~/.local/state/tmux-harpoon/pins.txt` by default. Ask the tool rather than
guessing:

```
uv run harpoon.py path
```

Blank lines and lines starting with `#` are ignored, so the file carries its own
header and can hold notes.

## WHY

Reaching a session otherwise costs the session-switcher key, a fuzzy filter and
a lookup. Harpoon solves the same problem for files inside nvim by keeping a
small positional list: one keystroke, no prompt. This is the tmux half of that
idea.

Why function keys: `Ctrl+1` to `Ctrl+9` are unusable under a legacy terminal
encoding, since they collapse to the same bytes as `Ctrl+Space`, `Ctrl+\` and
backspace, and tmux 3.8 only requests xterm `modifyOtherKeys`, which kitty
ignores. Function keys report unique sequences, so they survive every layer.

## HOW

```
uv run harpoon.py <subcommand> [--file PATH]

jump <n>|last   switch the client to the session on line n, or the last line
pin             append the current session if it is not already there
edit            seed from live sessions when empty, then open the list in nvim
list            print the list with key, session name and a (gone) marker
path            print the pins file path, creating nothing
setup           create the pins file and seed it from live sessions
```

`--file PATH` overrides the pins file, which is what the tests use.

The editor opens as a tmux `display-popup` running nvim with line numbers and
`autowriteall`, so reordering with `dd` and `p` then `:q` saves the new order
without typing `:w`. `:q!` discards instead.

### Bindings

`.tmux.conf` holds the block between `SESSION PINS ... - BEGIN` and `- END`:
twelve root bindings for the function keys, plus `prefix e` to edit and
`prefix a` to pin. They call the script by absolute path through `uv run`.

## Tests

Unit tests, no tmux needed:

```
cd wayland/scripts/tmux/harpoon
uv run test_harpoon.py
```

One class or one test:

```
uv run test_harpoon.py JumpTests -v
```

Lint and format, as the repo requires:

```
uvx ruff check .
uvx ruff format --check .
```

The suite never touches the real pins file: every path is a temporary directory
or an explicit `--file`, and `StatePathTests` pins that behaviour down.

### Manual end-to-end check

Automated coverage stops at the tmux boundary. To verify the whole loop without
touching your live sessions, use an isolated server:

```
tmux -L pins-demo -f /dev/null new -d -s alpha
tmux -L pins-demo new -d -s beta
XDG_STATE_HOME=/tmp/pins-demo kitty tmux -L pins-demo attach -t alpha
```

Inside that window: `prefix e` seeds and opens the editor, reorder a line, `:q`,
then `Ctrl+F1` and `Ctrl+F12` should move between the two sessions. When done,
`tmux -L pins-demo kill-server` removes the server and its sessions.
