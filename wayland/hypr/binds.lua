-- Key bindings
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"

----------------
---- CORE ----
----------------

hl.bind(mainMod .. " + Return",          hl.dsp.exec_cmd("kitty"),          { description = "kitty" })
hl.bind(mainMod .. " + SHIFT + Return",  hl.dsp.exec_cmd("ghostty"),        { description = "ghostty" })
hl.bind(mainMod .. " + D",               hl.dsp.exec_cmd("/storage/src/dot_files/wayland/scripts/hyprland-cheatsheet.sh"), { description = "this cheatsheet" })
hl.bind(mainMod .. " + H",               hl.dsp.exec_cmd("kitty --title \"Commands Cheatsheets\" -o confirm_os_window_close=0 ~/scripts/cheats-commands.sh"), { description = "commands cheatsheets" })
hl.bind(mainMod .. " + SHIFT + J",       hl.dsp.exec_cmd("pypr wall next"), { description = "next wallpaper" })
hl.bind(mainMod .. " + SHIFT + K",       hl.dsp.exec_cmd("loupe /storage/src/dot_files/mechanical-keyboards/corne-v4/images/split-keyboard-corne-v4-layers.png"), { description = "corne v4 split keyboard layout" })
hl.bind(mainMod .. " + Q",               hl.dsp.exec_cmd("~/scripts/powermenu-hypr.sh"), { description = "power menu" })
hl.bind(mainMod .. " + R",               hl.dsp.exec_cmd("~/scripts/wayland-reload.sh"), { description = "reload hyprland/pyprland/waybar" })
hl.bind(mainMod .. " + T",               hl.dsp.exec_cmd("/storage/src/dot_files/wayland/scripts/tmux-cheatsheet.sh"), { description = "tmux cheatsheet" })

----------------
---- APPS ----
----------------

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | wofi --show dmenu | cliphist decode | wl-copy"), { description = "select entry from clipboard" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("vicinae toggle"), { description = "open applications/clipboard/etc.. (vicinae)" })
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("/storage/src/dot_files/wayland/scripts/screen-record.sh"), { description = "record/capture video from selected screen area" })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("wayscriber --active"), { description = "take screenshot (F2 toggle floating panels, Ctrl+Shift+S select region)" })
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("pypr toggle terminal"), { description = "scratchpad: terminal" })
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("swaync-client -t -sw"), { description = "show notifications" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pypr toggle volume"), { description = "scratchpad: volume control" })

------------------
---- SCRIPTS ----
------------------

hl.bind("CTRL + Period", hl.dsp.exec_cmd("kitty --title \"Snippet Selector\" ~/scripts/snippets-fzf.sh"), { description = "text snippets fzf" })
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/scripts/browser-bookmarks.sh"), { description = "copy browser bookmark to clipboard" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/scripts/pass-menu.sh"), { description = "decrypt password (pass)" })
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("kitty --title \"AI Prompt Popup\" -o confirm_os_window_close=0 /storage/src/dot_files/wayland/scripts/ai-prompt-popup.sh"), { description = "AI prompt select" })

------------------
---- VOLUME ----
------------------

hl.bind("ALT + Up",   hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"), { description = "volume up" })
hl.bind("ALT + Down", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"), { description = "volume down" })
hl.bind("ALT + M",    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { description = "volume mute" })

--------------------
---- WINDOWS ----
--------------------

-- Controls
hl.bind(mainMod .. " + Backspace",   hl.dsp.window.kill(),                                      { description = "window: close" })
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.window.float({ action = "toggle" }),                { description = "window: float" })
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen(),                                 { description = "window: fullscreen" })
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.layout("swapwithmaster"),                          { description = "window: swap with master" })
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.layout("mfact +0.1"),                              { description = "window: expand master split size" })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.layout("mfact -0.1"),                             { description = "window: shrink master split size" })
hl.bind(mainMod .. " + TAB",         hl.dsp.focus({ last = true }),                             { description = "window: focus last window" })
hl.bind("ALT + TAB",                 hl.dsp.exec_cmd("~/scripts/hyprland-go-to-window.sh"),      { description = "window: select from menu" })

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }), { description = "window: go to left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }), { description = "window: go to right" })
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }), { description = "window: go up" })
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }), { description = "window: go down" })

-- Navigate (scrolling layout)
hl.bind(mainMod .. " + J", hl.dsp.layout("focus d"), { description = "Focus next window (scroll down)" })
hl.bind(mainMod .. " + K", hl.dsp.layout("focus u"), { description = "Focus previous window (scroll up)" })

-- Swap windows
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "l" }), { description = "window: go to left" })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "r" }), { description = "window: go to right" })
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "u" }), { description = "window: go up" })
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "d" }), { description = "window: go down" })

-- Mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "movewindow" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "resizewindow" })

-----------------------------------------
---- MOVE WINDOW TO WORKSPACE (FOLLOW) ----
-----------------------------------------

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }),  { description = "window: move current to workspace 1 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }),  { description = "window: move current to workspace 2 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }),  { description = "window: move current to workspace 3 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }),  { description = "window: move current to workspace 4 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }),  { description = "window: move current to workspace 5 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }),  { description = "window: move current to workspace 6 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }),  { description = "window: move current to workspace 7 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }),  { description = "window: move current to workspace 8 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }),  { description = "window: move current to workspace 9 and switch to it" })
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }), { description = "window: move current to workspace 10 and switch to it" })

------------------------------------------------
---- MOVE WINDOW TO WORKSPACE (SILENT / NO FOLLOW) ----
------------------------------------------------

hl.bind(mainMod .. " + ALT + 1", hl.dsp.window.move({ workspace = 1, follow = false }),  { description = "window: move current to workspace 1 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 2", hl.dsp.window.move({ workspace = 2, follow = false }),  { description = "window: move current to workspace 2 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 3", hl.dsp.window.move({ workspace = 3, follow = false }),  { description = "window: move current to workspace 3 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 4", hl.dsp.window.move({ workspace = 4, follow = false }),  { description = "window: move current to workspace 4 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 5", hl.dsp.window.move({ workspace = 5, follow = false }),  { description = "window: move current to workspace 5 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 6", hl.dsp.window.move({ workspace = 6, follow = false }),  { description = "window: move current to workspace 6 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 7", hl.dsp.window.move({ workspace = 7, follow = false }),  { description = "window: move current to workspace 7 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 8", hl.dsp.window.move({ workspace = 8, follow = false }),  { description = "window: move current to workspace 8 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 9", hl.dsp.window.move({ workspace = 9, follow = false }),  { description = "window: move current to workspace 9 and DO NOT switch to it" })
hl.bind(mainMod .. " + ALT + 0", hl.dsp.window.move({ workspace = 10, follow = false }), { description = "window: move current to workspace 10 and DO NOT switch to it" })

--------------------
---- CURSOR ZOOM ----
--------------------

hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor \"$(hyprctl -j getoption cursor:zoom_factor | jq '.float + 1.0')\""), { description = "Increase cursor zoom" })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor \"$(hyprctl -j getoption cursor:zoom_factor | jq 'max(.float - 1.0; 1.0)')\""), { description = "Decrease cursor zoom (not below 1.0)" })
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1.0"), { description = "Reset cursor zoom" })

-----------------------
---- WORKSPACES ----
-----------------------

-- Switch workspaces
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }),  { description = "workspace: go to 1" })
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }),  { description = "workspace: go to 2" })
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }),  { description = "workspace: go to 3" })
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }),  { description = "workspace: go to 4" })
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }),  { description = "workspace: go to 5" })
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }),  { description = "workspace: go to 6" })
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }),  { description = "workspace: go to 7" })
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }),  { description = "workspace: go to 8" })
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }),  { description = "workspace: go to 9" })
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }), { description = "workspace: go to 10" })

hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd("~/scripts/hyprland-move-current-workspace.sh"), { description = "workspace: move current to other monitor" })
hl.bind(mainMod .. " + SHIFT + W",  hl.dsp.exec_cmd("~/scripts/hyprland-move-selected-workspace.sh"), { description = "workspace: move selected to other monitor" })

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }), { description = "workspace: mouse scroll up to next" })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }), { description = "workspace: mouse scroll down to previous" })