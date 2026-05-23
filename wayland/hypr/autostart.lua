-- Startup applications
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
  hl.exec_cmd("~/scripts/gtk-set-theme.sh")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("systemctl --user mask xdg-desktop-portal-gnome")
  hl.exec_cmd("/usr/bin/swaync")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=gpg,ssh")
  hl.exec_cmd("pypr --debug ~/.local/state/hyprland/pypr.log")
  hl.exec_cmd("~/scripts/wayland-reload.sh > ~/.local/state/hyprland/wayland-reload.log 2>&1")
  hl.exec_cmd("vicinae server > ~/.local/state/hyprland/vicinae-server.log 2>&1")
  hl.exec_cmd("wl-paste --watch ~/scripts/clipwatch.sh")
  hl.exec_cmd("~/scripts/desktop-portals.sh")
  hl.exec_cmd("/usr/bin/swayosd-server")
  hl.exec_cmd("/usr/bin/hypridle")
  hl.exec_cmd("~/scripts/monitor-clipboard-file.sh > ~/.local/state/hyprland/monitor-clipboard-file.log 2>&1")
end)

