# TODO - finish the Quickshell migration

The cutover is done and the bar is stable. What remains is removal work.

## 1. Remove Waybar

Waybar no longer starts and nothing reads its config. Three things still exist:

- `wayland/waybar/` in the repo: `config`, `style.css`, `colors-waybar.css`.
- `/usr/bin/waybar`, installed from `extra`.
- `/usr/lib/systemd/user/waybar.service`, `disabled` and `inactive`.

Steps, in order:

1. Confirm the new bar has been stable for a few days: `pgrep -x quickshell` returns one PID, and
   `hyprctl layers` shows one `namespace: quickshell` surface per monitor.
2. Delete the repo config: `git rm -r wayland/waybar` from `/storage/src/dot_files`, then commit.
   No other file reads those three files.
3. Remove the package: `sudo pacman -Rns waybar`. That also removes the unit and the defaults under
   `/etc/xdg/waybar`.
4. Verify: `pacman -Q waybar` errors with "not found", and `pgrep -x waybar` prints nothing.

Do not skip step 1. Until the package is gone, `waybar` is the only bar fallback; the bar itself ships
no fallback path.

`waybar/config` declares 22 modules but only 14 were ever in a module list. The other eight
(`custom/outlook`, `custom/exit`, `idle_inhibitor`, `temperature`, `backlight`, `network`,
`custom/media`, `battery#bat2`) are dead, and their `style.css` rules are orphaned with them.
`colors-waybar.css` is imported only by `waybar/style.css`. Step 2 deletes all of it; nothing needs
porting.

## 2. Delete the file-gate backups

62 `*.BKP.*` files sit beside the QML sources under `wayland/quickshell/`. They are backups, not part
of the implementation, and must not be committed. Once the bar has been stable:

```bash
find wayland/quickshell -name '*.BKP.*' -delete
```

## 3. Open caveat: `Variants` and monitor hotplug

Quickshell 0.3.2 has a documented bug where `Variants` does not reliably create or destroy its
delegates while `Quickshell.screens` changes. `shell.qml` uses exactly that shape to build one bar per
screen.

- Symptom: a monitor is added or removed and the bar count no longer matches the monitor count, or a
  monitor shows no bar.
- Recovery: `~/scripts/wayland-reload.sh`. If the count is still wrong, derive the Hyprland signature,
  `pkill -x quickshell`, then `setsid quickshell > /tmp/qs.log 2>&1 </dev/null &`.
- Not guarded in code. A count check plus `Quickshell.reload(false)` was considered and rejected: it is
  speculative code for a bug never observed here. If hotplug becomes a daily annoyance, that guard is
  the first thing to add.

## 4. Open decision: blur behind the bar

`hypr/window-rules.lua` matches the `quickshell` layer namespace and enables blur with
`ignore_alpha = 0.1`. This is new behaviour, not parity: the old top bar had no layer rule. Keep it or
delete the `blur-quickshell-bar` block; nothing else depends on it.
