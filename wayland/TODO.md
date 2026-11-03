# TODO - finish the Waybar to Quickshell migration

The cutover is done: one `quickshell` process draws one bar per monitor, Waybar no longer starts, and
`~/scripts/wayland-reload.sh` reloads the new bar. What remains is the removal work below, and one
upstream caveat worth knowing before it bites.

Nothing here is a bug in the new bar. Every item is either a deletion that was deliberately deferred or
an environment note.

## 1. Remove Waybar

Verified state at the time of the cutover:

- `waybar/config`, `waybar/style.css`, `waybar/colors-waybar.css` are still in the repo at
  `/storage/src/dot_files/wayland/waybar/`. Nothing reads them any more.
- `waybar.service` is `disabled` and `inactive`. The bar was never service-managed; it was a child of
  `~/scripts/wayland-reload.sh`, and that script no longer starts it.
- The binary is `/usr/bin/waybar`, installed from `extra`.

Steps, in order:

1. Confirm the new bar has been stable for a few days: `pgrep -x quickshell` returns one PID, and
   `hyprctl layers` shows one `namespace: quickshell` surface per monitor at `y=0`.
2. Delete the repo config: `git rm -r wayland/waybar` from `/storage/src/dot_files`, then commit. This
   removes `config`, `style.css`, and `colors-waybar.css` together. No other file references them.
3. Remove the package: `sudo pacman -Rns waybar`. The package owns `/usr/bin/waybar`,
   `/usr/lib/systemd/user/waybar.service`, and the system defaults under `/etc/xdg/waybar`. All three
   go with it.
4. Verify: `pacman -Q waybar` errors with "not found", and `pgrep -x waybar` prints nothing.

Do not skip step 1. If the new bar is unstable, `waybar` is the only fallback, and removing the package
deletes it. The design deliberately ships no in-bar fallback path.

## 2. Recover the bar if it dies

The bar is not a systemd unit, by decision. Recovery is the reload script, which already handles a dead
bar:

```bash
~/scripts/wayland-reload.sh
```

That script reloads swaync, runs `hyprctl reload`, calls `qs ipc call island reload`, and if that IPC
call fails it kills and respawns the bar with a `pgrep` guard. It then reloads pypr.

Manual recovery, when the script itself is suspect:

```bash
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/1000/hypr/*/hyprland.lock | head -1 | xargs dirname | xargs basename)
pkill -x quickshell
setsid quickshell > /tmp/qs.log 2>&1 </dev/null &
```

The signature export matters: a stale `HYPRLAND_INSTANCE_SIGNATURE` in an inherited shell makes the bar
start without Hyprland IPC, which blanks the workspaces and the window title.

Useful commands: `qs ipc show`, `qs ipc call island setMode full`, `qs ipc call island setMode compact`,
`qs ipc call island toggleMode`, `qs ipc call island reload`. `SUPER + N` does the same toggle from the
keyboard.

The bar starts at login from `hypr/autostart.lua`, line 14:
`hl.exec_cmd("pgrep -x quickshell >/dev/null || quickshell")`. The `pgrep` guard is what stops a
`hyprctl reload` from starting a second copy.

## 3. Known caveat: `Variants` and monitor hotplug

Quickshell 0.3.2 has a documented bug where `Variants` does not reliably create or destroy its delegates
while `Quickshell.screens` changes. `shell.qml` uses exactly that shape to build one bar per screen.

- Symptom: a monitor is added or removed and the bar count no longer matches the monitor count, or a
  monitor shows no bar.
- Recovery: `qs ipc call island reload`. If the count is still wrong, the manual `pkill` and `setsid`
  sequence in section 2 is reliable.
- Not guarded in code. A count check plus `Quickshell.reload(false)` was considered and rejected: it is
  speculative code for a bug never observed here, and it adds a second reload path that can itself
  misbehave. If hotplug becomes a daily annoyance, that guard is the first thing to add.

## 4. Orphaned Waybar CSS and dead module blocks

Worth knowing if the directory is kept instead of deleted: `waybar/config` declares 22 modules, but only
14 appear in a module list. The other eight are dead, and their `style.css` rules are orphaned with them:

- `custom/outlook`, `custom/exit`, `idle_inhibitor`, `temperature`, `backlight`, `network`,
  `custom/media`, `battery#bat2`.

`colors-waybar.css` is imported only by `waybar/style.css`. Deleting the directory in section 1 removes
all of it. Nothing needs porting: none of those eight modules render in the new bar, by design.

`style.css` also carries several unitless `font-size` and `padding` declarations that GTK ignores. The
effective size came from the 14 px global rule, which is what the new bar uses.

## 5. Housekeeping inside `wayland/quickshell/`

- About 62 `*.BKP.*` files sit beside the QML sources. They are backups from the file gate, not part of
  the implementation, and must not be committed. To delete them once the bar has been stable:
  `find wayland/quickshell -name '*.BKP.*' -delete`
- The 20 QML files under `wayland/quickshell/` are still untracked in git. They need one commit.
  `~/.config/quickshell` is a symlink to `/storage/src/dot_files/wayland/quickshell`, matching the
  `hypr/` and `waybar/` layout.
- The two `.fonts/.uuid` deletions in the working tree predate this work and are unrelated.

## 6. Blur behind the bar

`hypr/window-rules.lua` matches the `quickshell` layer namespace and enables blur with
`ignore_alpha = 0.1`. This is new behaviour, not parity: the old top bar had no layer rule. If it is
unwanted, delete the `blur-quickshell-bar` block; nothing else depends on it.
