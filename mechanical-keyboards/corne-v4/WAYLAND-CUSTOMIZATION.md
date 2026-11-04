# Custom XKB layout for the cedilla on Wayland (Hyprland)

Last updated: 2026-11-04

## What this document covers

How the `ç` character was made typeable on this Corne v4 under Hyprland on Wayland, why the obvious approaches did not work, and how to recreate or update the setup after a reinstall or a firmware change.

## Result

Typing `ç` is `Fn1` plus `C`. It works in every application, because the host layout decides the character, not the application and not Vial.

| Piece | Where | What it does |
|---|---|---|
| Firmware key | Corne v4, layer 1, row 2, column 3, the position that holds `C` on layer 0 | Sends `KC_SCROLLLOCK` |
| Host layout | `/storage/src/dot_files/xkb/symbols/corne-cedilla` | Reproduces `us(intl)` and maps the Scroll Lock keycode to `ccedilla` |
| Symlink | `~/.config/xkb` points at `/storage/src/dot_files/xkb` | Lets libxkbcommon find the layout |
| Hyprland | `wayland/hypr/hyprland.lua` | `kb_layout = "corne-cedilla"` |

## Why the problem exists

Two independent facts meet:

1. This board has 42 keys and no AltGr (level 3) shift key. The `us` layout family puts `ç` on level 3 of the comma key, so it is unreachable on this hardware.
2. HID has no keycode for `ç`. A keyboard reports usage codes such as `KC_C` or `KC_SCROLLLOCK`, and only the operating system layout turns one of those into a letter. No firmware change can emit `ç` on its own.

The other Portuguese accents worked from the start because they come from level 1 dead keys, which this board reaches without any modifier.

## Approaches that failed, worth knowing before retrying

**F13 as the firmware keycode.** The evdev rules append `inet(evdev)` after the layout. That file maps `FK13` through `FK24` to XF86 keysyms, so a `key <FK13> { [ ccedilla ] };` line in the layout is replaced by `XF86Tools` and never reaches an application. Any carrier keycode must survive that later merge.

**Scroll Lock as a combo output.** The combo `KC_C` plus `KC_QUOTE` with a 30 ms term worked, but two problems appeared. Simultaneous presses were easy to miss, and QMK holds combo member keys until the term expires, so `c` and `'` gained latency on every keystroke. A layer key replaced it, because a layer key fires on press with no window and no buffering.

**Why Scroll Lock is the right carrier.** `symbols/pc` defines `SCLK`, and the rules include `pc` before the layout, so the override wins. `inet(evdev)` does not touch it, nothing on this system binds Scroll Lock, and the Corne sends it from no other position.

## 1. Firmware change in Vial

Target: layer 1, row 2, column 3. On layer 0 that position holds `KC_C`. On layer 1 it previously held `LSFT(KC_BSLASH)`, the pipe character.

Steps:

1. Open Vial. The udev rule at `/etc/udev/rules.d/59-vial.rules` grants access without sudo.
2. Select layer 1.
3. Click the `C` position and set it to `Scroll Lock`, or use the `Any` field and enter `KC_SCROLLLOCK`.
4. The change applies to EEPROM immediately. There is no separate save for the device.
5. Export a `.vil` into `saved-layouts/`.

Side effect: `|` is no longer on `Fn1` plus `C`. It remains reachable as Shift plus the `/` position on layer 1, and the same position on layer 2 also sends `KC_BSLASH`, so Shift gives `|` there as well.

Current firmware state: `saved-layouts/after-cedilla.20261104-162823.vil`. Loading that file in Vial restores the change.

## 2. Host layout file

Path: `/storage/src/dot_files/xkb/symbols/corne-cedilla`

```
default partial alphanumeric_keys modifier_keys
xkb_symbols "intl" {
    include "us(intl)"
    name[Group1] = "US intl with cedilla on Scroll Lock";
    key <SCLK> { [ ccedilla ] };
};
```

Details that matter:

- `include "us(intl)"` reproduces the existing layout, so every accent and every AltGr position stays identical to the previous setup.
- The stanza is named `intl` and marked `default`, so the existing `kb_variant = "intl"` keeps working and only `kb_layout` has to change in Hyprland.
- `ccedilla` is the X11 keysym for the lowercase character. `Ccedilla` exists for the uppercase form if it is ever needed.

## 3. Symlink

```
~/.config/xkb  ->  /storage/src/dot_files/xkb
```

libxkbcommon reads user layouts from `$XDG_CONFIG_HOME/xkb`, falling back to `$HOME/.config/xkb` when that variable is unset, as it is on this machine. The symlink keeps the single source of truth in the dotfiles repository.

Risk: if the repository path moves, `corne-cedilla` becomes unresolvable and the keyboard comes up with a broken layout at the next login.

## 4. Hyprland configuration

File: `/storage/src/dot_files/wayland/hypr/hyprland.lua`, inside the `input` table:

```
kb_layout = "corne-cedilla",
kb_variant = "intl",
kb_model = "",
kb_options = "lv3:ralt_switch",
kb_rules = "",
```

Only `kb_layout` changed. `lv3:ralt_switch` stays because it keeps right Alt as the level 3 shift, which is what makes the AltGr positions of `us(intl)` reachable.

Apply with `hyprctl reload`.

## 5. Verification

Compile the layout first, before involving Hyprland:

```
xkbcli compile-keymap --layout corne-cedilla --variant intl > /dev/null && echo COMPILES
xkbcli compile-keymap --layout corne-cedilla --variant intl | grep -n ccedilla
```

Expected: `COMPILES`, plus a line reading `key <SCLK> { [ ccedilla ] };`. A second line for `key <AB08>` is the built in comma mapping and is expected.

After the reload:

```
hyprctl getoption input:kb_layout
```

Expected `str: corne-cedilla`. The compositor log also confirms the keymap was built: `[IKeyboard::setKeymap] Attempting to create a keymap for layout corne-cedilla with variant intl`.

## 6. Troubleshooting

**`hyprctl` reports `Couldn't connect to ... .socket.sock`.** The `HYPRLAND_INSTANCE_SIGNATURE` in that shell points at a dead instance, usually after a compositor restart. Open a fresh terminal, or run `env -u HYPRLAND_INSTANCE_SIGNATURE hyprctl ...`.

**`xkbcomp` warnings from Xwayland.** Messages about a maximum keycode being clipped, or about `Hyper` and `ScrollLock` virtual modifiers being multiply defined, are warnings and not errors. Xwayland states that they are not fatal.

**The chord produces nothing.** Check, in order: the symlink resolves, the layout file exists, `xkbcli` compiles, `hyprctl` reports `corne-cedilla`, and the Vial key still emits Scroll Lock. Restart Chromium and Slack if only those two fail, since they can hold a keymap from startup.

## 7. Updating the character

Change `ccedilla` to another keysym name inside `key <SCLK> { ... };`, run the compile check, then `hyprctl reload`. Keysym names are listed in `/usr/include/X11/keysymdef.h`, written without the `XK_` prefix.

## 8. Rollback

1. Set `kb_layout = "us"` in `hyprland.lua` and run `hyprctl reload`.
2. Remove the symlink with `unlink ~/.config/xkb`.
3. In Vial, load `saved-layouts/before-cedilla.20261104-161026.vil` to restore the firmware.

Step 1 alone undoes the host side, because the custom layout file is only read when `corne-cedilla` is requested.

## 9. A second way to type `ç`, needing none of this

`us(intl)` carries `ccedilla` on level 3 of the comma key. Because `lv3:ralt_switch` is active and layer 1 puts `KC_RALT` on a right thumb key, `Fn1` plus that thumb plus `,` also produces `ç`. That path works even with `kb_layout = "us"` and needs no custom layout file.

## Files involved

| Path | State |
|---|---|
| `xkb/symbols/corne-cedilla` | New |
| `~/.config/xkb` | New symlink pointing at `xkb/` |
| `wayland/hypr/hyprland.lua` | One line changed, `kb_layout` |
| `mechanical-keyboards/corne-v4/saved-layouts/after-cedilla.20261104-162823.vil` | Firmware state with the cedilla key |
| `mechanical-keyboards/corne-v4/WAYLAND-CUSTOMIZATION.md` | This document |
