#!/usr/bin/env bash
# Hyprland keybinding cheatsheet
# Queries all registered bindings from the running Hyprland instance
# and displays them in wofi with description + key combination
set -euo pipefail

entries=$(hyprctl binds -j | jq -r '
  # Convert modmask integer to a "+" separated list of modifier names
  def modmask_to_mods:
    . as $m
    | [
        (if ($m / 64 | floor) % 2 == 1 then "SUPER" else empty end),
        (if ($m / 32 | floor) % 2 == 1 then "MOD3"  else empty end),
        (if ($m / 16 | floor) % 2 == 1 then "MOD2"  else empty end),
        (if ($m / 8  | floor) % 2 == 1 then "ALT"   else empty end),
        (if ($m / 4  | floor) % 2 == 1 then "CTRL"  else empty end),
        (if ($m / 2  | floor) % 2 == 1 then "CAPS"  else empty end),
        (if $m % 2 == 1                then "SHIFT" else empty end)
      ]
    | join(" + ")
  ;

  .[]
  | select(.has_description and .description != "")
  | (.modmask | modmask_to_mods) as $mods
  | (if $mods == "" then "" else $mods + " + " end) + .key as $combo
  | "<span weight=\"bold\" foreground=\"#ffffff\">" + .description
    + "</span>  <span foreground=\"#888888\">"
    + $combo + "</span>"
' | sort)

# Exit silently if no bindings found (should not happen under normal operation)
[ -z "$entries" ] && { notify-send "Hyprland Cheatsheet" "No bindings found"; exit 1; }

selected=$(echo "$entries" | wofi --show dmenu --prompt "Select a binding:" --allow-markup)

if [ -n "$selected" ]; then
  # Strip Pango markup for the notification
  stripped=$(echo "$selected" | sed 's/<[^>]*>//g')
  notify-send "Hyprland Binding" "$stripped"
fi
