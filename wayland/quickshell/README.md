# quickshell

A Quickshell configuration that draws a single "dynamic island" bar on top of
every monitor. It replaces the traditional text-only bar with one rounded
island that expands on hover and keeps per-widget popups (calendar, battery,
tray menu, OpenCode usage) anchored to itself.

## WHAT

### What this is

- A Quickshell config rooted at `shell.qml`. It is installed by symlinking this
  folder to `~/.config/quickshell`:
  `~/.config/quickshell -> /storage/src/dot_files/wayland/quickshell`.
- Started by Hyprland with
  `hl.exec_cmd("pgrep -x quickshell >/dev/null || quickshell")`
  (see `wayland/hypr/autostart.lua`).
- One `PanelWindow` per screen, created by
  `Variants { model: Quickshell.screens }`. Each panel is a full-width,
  transparent, 40 px tall strip that reserves 43 px of exclusive zone.
- The panel input region is masked to the island rectangle only
  (`mask: Region { item: island }`), so every click outside the island reaches
  the window below it.
- Two visual modes, held in `Singleton/State.qml`:
  - `compact`: left cluster, center cluster, and the OpenCode widget are
    visible. The right cluster and the OpenRouter widget are collapsed to
    zero width.
  - `full`: everything is visible. Entered on hover, left automatically 2 s
    after the pointer leaves (`collapseDelayMs: 2000`).

### What is on the bar

Left to right, in `Modules/Bar.qml`:

| Module | Source | Interaction |
|---|---|---|
| `Workspaces` | `Quickshell.Hyprland` monitor model | click a workspace to focus it |
| `WindowTitle` | `Quickshell.Hyprland` | display only |
| `WeekInfo` | `~/scripts/week-info.sh` | click opens the calendar popup |
| `Clock` | local time, `ddd MMM dd - HH:mm:ss` | click opens the calendar popup |
| `FlowStatus` | `~/scripts/flow-status-waybar.sh` | click runs `flow-today-waybar.sh` |
| `Openrouter` | `~/scripts/openrouter-credits-balance-waybar.sh` | click opens the credits page (full mode only) |
| `OpencodeUsage` | OpenCode Go plan meters, cached | left click opens its popup, right click cycles the API key |
| `CapsLock` | `~/scripts/caps-lock-waybar.sh` | display only |
| `PulseAudio` | `Quickshell.Services.Pipewire` | display only |
| `Disk`, `Cpu`, `Memory` | `df`, `/proc/stat`, `/proc/meminfo` | display only |
| `BatteryWdg` | `Quickshell.Services.UPower` | click opens its popup |
| `Tray` | `Quickshell.Services.SystemTray` | click activates the item, right click opens its menu |

### File layout

| Path | Role |
|---|---|
| `shell.qml` | entry point, per-screen `Bar` instances, IPC handler |
| `Modules/Bar.qml` | the island itself: layout, mask, hover-to-expand |
| `Modules/*.qml` | one widget each, stateless, reading from `Singleton/Polls.qml` |
| `Widgets/` | reusable visual pieces (`Calendar`, `TrayMenu`) |
| `Singleton/Palette.qml` | every color, radius, size, font, and animation duration |
| `Singleton/Polls.qml` | every data source: timers, `Process` calls, `FileView` reads |
| `Singleton/State.qml` | island mode and which popup is open |
| `systemd/` | user units that keep the OpenCode usage cache fresh |

## WHY

**Why Quickshell and not waybar.** Three things need real Qt surfaces: centered
`PopupWindow`s anchored to a bar widget, a hover-driven width animation, and a
live tray menu. Waybar renders text and CSS boxes only, so the popups and the
island motion cannot be built there.

**Why one panel per screen with an input mask.** A full-width panel makes the
three-cluster layout trivial (left, center, right, centered with `Row`), while
the mask keeps the rest of the screen clickable. A narrow panel sized to the
island would have to be repositioned on every width change.

**Why three singletons.** `Variants` creates one `Bar` per screen, so any timer,
process, or HTTP call placed inside a module would run once per monitor. All
polling lives in `Polls.qml` and all shared state in `State.qml`, so two
monitors cost the same number of API calls as one. `Palette.qml` exists so a
color or radius is never written twice.

**Why widgets read JSON from scripts.** The scripts under `wayland/scripts/`
were written for waybar first and speak the waybar contract:
`{"text", "class", "tooltip"}` on stdout with `return-type: json`. Keeping that
contract lets the same script feed waybar and quickshell, and it keeps the
privileged work (pass, curl, UPower-free reads) out of QML.

**Why the OpenCode usage is cached by a systemd user timer.** The widget used to
run `uv run opencode_go_usage.py --widget` itself on every right click and every
60 s. Measured on this machine: 320 to 480 ms per run (uv startup, `pass show`,
and a 190 to 230 ms API round trip). Two consequences:

1. The click felt unresponsive, and the popup showed the previous key's numbers
   until the child process exited.
2. When the gpg-agent cache had expired, `pass show` opened pinentry and the
   widget waited for a human, which is unbounded.

The timer decouples fetching from rendering: the fetch happens every 10 minutes
in `opencode-go-usage.service`, writes one JSON file per key, and the widget
only reads that file. Reading a small file costs microseconds, so the popup and
the key switch render immediately.

**Why the age line is green and exact.** Once the data is cached, the age is
part of the information. The popup prints the lag and the wall-clock moment of
the last successful fetch (`8 minutes ago, at 10:01:15`) in green, so stale
numbers are never mistaken for live ones.

## HOW

### Run, reload, control

```bash
quickshell                       # run in the foreground (Ctrl+C to stop)
qs ipc call island reload        # reload the QML in the running instance
qs ipc call island setMode full  # force a mode: full or compact
qs ipc call island toggleMode    # flip the mode
```

Read QML warnings with `journalctl --user -f --identifier=quickshell` or by
reading the terminal that launched `quickshell`.

### The polling contract

Every script-backed widget follows the same three steps:

1. The script prints one JSON object on stdout: `text` (may contain Pango-style
   spans), `class` (a state name the QML maps to a color), `tooltip` (plain
   multi-line text).
2. `Singleton/Polls.qml` owns the `Process` and the `Timer` that runs it, and
   stores the parsed object in a property such as `Polls.flow`.
3. The module in `Modules/` reads that property and draws it. It never starts a
   process itself.

For files that change on their own (`/proc/stat`, `/proc/meminfo`) `Polls.qml`
uses `FileView` plus a `Timer` that calls `reload()`. The OpenCode cache is read
with a two-line `Process` running `cat` instead, because `FileView` keeps
returning the previous file's text until a newly set path finishes loading, and
the cache path changes on every key switch. The timer that re-reads it runs
every 10 s and costs a few milliseconds.

### Add a module

1. Write `~/scripts/my-thing.sh` and test it by hand. It must print
   `{"text": "...", "class": "...", "tooltip": "..."}`.
2. In `Singleton/Polls.qml` add `property var myThing: ({ text: "" })`, a
   `Timer`, a `Process` with a `StdioCollector`, and set the property in
   `onStreamFinished` through `root.parseJson(text, root.myThing)`.
3. In `Modules/MyThing.qml` copy the shape of `Modules/WeekInfo.qml`: an `Item`
   of `implicitWidth: label.implicitWidth + 20` and
   `implicitHeight: S.Palette.islandHeight`, a centered `Text` using
   `S.Palette` values, and a `TapHandler` if it needs one.
4. Add `MyThing {}` to the correct `Row` in `Modules/Bar.qml`.
5. Reload with `qs ipc call island reload`.

### Styling rules

- Colors, radii, font family, font size, and animation durations come from
  `Singleton/Palette.qml`. Do not inline a hex color in a module.
- Every widget is `implicitHeight: S.Palette.islandHeight` tall and adds 20 px
  of horizontal padding around its text.
- Animate with `Behavior on <property> { NumberAnimation { duration:
  S.Palette.motionMs; easing.type: Easing.OutCubic } }`.
- Popups follow the `PopupWindow` + `Rectangle` + `Behavior on opacity/scale`
  pattern used by `Modules/Clock.qml`, anchored to `root.panel`.

### OpenCode Go usage cache

This is the only module whose data does not come straight from a script call.

**Key list.** `/storage/src/aikt/pi/opencode-go-keys.txt`, one key per line:

```
<label> | <pass entry>
```

Only lines containing `READ` are listed by the widget, but that label is not
the permission that matters: `GET /api/go/status` answers HTTP 403 to any key
that is not set to **Read only** in the console. Today the
`..._rocky_api_key_two` entry is `WRITE & READ`, so it can call models but
cannot read the Go status, and it never produces a cache file. The service logs
one `skipped` line per run for it and keeps the unit green. The selected key is
persisted in `~/.local/state/quickshell/opencode-account`.

**Cache.** `opencode-go-usage.service` runs
`wayland/scripts/opencode-go-cache.sh`, which fetches every `READ` key, skips
any key the API refuses with HTTP 403, and writes one file per working key to:

```
~/.local/state/quickshell/opencode-usage/<slug>.json
```

`<slug>` is the pass entry with every character outside `[A-Za-z0-9]` replaced
by `_`. Each file holds the waybar payload plus `fetchedAt`, an epoch
millisecond timestamp. Writes are atomic (temporary file, then rename, mode
0600), so a reader never sees a half-written file.

**Timer.** `systemd/opencode-go-usage.timer` fires 15 s after login and every
10 minutes after that (`OnActiveSec=15s`, `OnUnitInactiveSec=10min`). Ten
minutes is the freshness interval the Captain chose: long enough to keep the
API quiet, short enough to be useful.

**Install the units once:**

```bash
ln -s /storage/src/dot_files/wayland/quickshell/systemd/opencode-go-usage.service ~/.config/systemd/user/opencode-go-usage.service
ln -s /storage/src/dot_files/wayland/quickshell/systemd/opencode-go-usage.timer ~/.config/systemd/user/opencode-go-usage.timer
systemctl --user daemon-reload
systemctl --user enable --now opencode-go-usage.timer
systemctl --user start opencode-go-usage.service
```

**Operate it:**

```bash
systemctl --user list-timers opencode-go-usage.timer   # next and last run
systemctl --user start opencode-go-usage.service       # refresh now
journalctl --user -u opencode-go-usage.service -n 30   # what happened
jq . ~/.local/state/quickshell/opencode-usage/*.json   # what the widget sees
```

**The passphrase rule.** The service runs `pass` with
`PASSWORD_STORE_GPG_OPTS=--pinentry-mode=error`. A background timer must never
open a passphrase dialog on its own, so when the gpg-agent cache has expired
the run fails fast, logs the failure, and the cache simply stays old. The age
line in the popup shows how old. To recover: unlock `pass` once in a terminal
(`pass show api-keys/... > /dev/null`) and then
`systemctl --user start opencode-go-usage.service`. Each successful run resets
the agent's idle timer, so with `default-cache-ttl 21600` one unlock covers a
whole working day.

**The age line.** The popup prints, under the key name, in `S.Palette.ok`
(`#00FF00`):

```
8 minutes ago, at 10:01:15
```

The relative part uses `just now` under a minute, then minutes, hours, and days,
with singular forms. The wall-clock part is local time, formatted
`HH:mm:ss`. A key that has never been fetched shows `never fetched`. The line
ticks every second while the popup is open.

**Script flags** (`wayland/scripts/opencode_go_usage.py`):

| Flag | Effect |
|---|---|
| `--widget` | print the waybar-compatible JSON payload |
| `--pass-entry ENTRY` | read the key from a different `pass` entry |
| `--cache-file PATH` | write the payload to `PATH` atomically instead of printing |

Without `--widget` the script prints the plain Console-style summary. The
waybar module in `wayland/waybar/config` still calls `--widget` every 60 s and
is unaffected by the cache.

### Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Widget shows `Go: no data` | no cache file for the selected key yet, or the selected key is not a read-only key | `systemctl --user start opencode-go-usage.service`, or cycle to a read-only key |
| Age line says `never fetched` | the timer has not run for this key | same as above |
| Age grows past 10 minutes | timer disabled, or every run is failing | `systemctl --user list-timers`, then `journalctl --user -u opencode-go-usage.service` |
| Journal shows `gpg: public key decryption failed` | gpg-agent locked, error mode refused to prompt | unlock `pass` once in a terminal, then start the service |
| Journal shows `HTTP 401` | key revoked or wrong permission level | create a new read-only key in the OpenCode console and update the pass entry |
| Journal shows `skipped ... may not read the Go status` | that key is not Read only, so `/api/go/status` answers HTTP 403 | create a read-only key for that account, or ignore the line |
| A popup is stuck open after a reload | `State.openPopup` kept the old name | click the widget again, or `qs ipc call island reload` |
| Nothing renders after an edit | QML error | `qs ipc call island reload` and read the quickshell log |
