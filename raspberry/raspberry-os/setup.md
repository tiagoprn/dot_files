# Tips

- To run programs on autostart, create `.desktop` files at `.config/autostart`


# Enabling i3 with its configuration:

- To change automatic graphical boot from pixl to i3, copy configuration at `etc/xdg/lxsession/LXDE-pi` and `usr/bin/i3wm-pi` to the same places on the pi filesystem (reference: <https://www.reddit.com/r/i3wm/comments/als8rt/i3_in_raspian/>).

- Copy the configuration from `i3` to `~/.config/i3` on the pi filesystem (for the pi user).


# Packages

## Desktop

### misc

unclutter (to hide mouse cursor)
matchbox-keyboard (on-screen keyboard)

### i3

i3-wm i3blocks i3lock-fancy i3status dmenu suckless-tools rofi rxvt-unicode xclip arandr pavucontrol mplayer mpv firefox-esr sxiv compton fonts-hack exiv2 libnotify-bin notification-daemon dbus

