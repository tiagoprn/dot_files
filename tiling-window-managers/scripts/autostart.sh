#!/bin/bash

LOG_FILE=/tmp/autostart.$(date +%Y-%m-%d).log

_isRunning() {
    ## function to check if a process is alive and running:
    ps -o args= -C "$1" 2>/dev/null | grep -x "$1" >/dev/null 2>&1
    ps aux | grep "$1" 2>/dev/null | grep -v "grep" >/dev/null 2>&1
}

# echo "Starting picom..." >> $LOG_FILE 2>&1
_isRunning picom || picom --config ~/picom.conf --backend glx >>$LOG_FILE 2>&1 &

# echo "Starting NetworkManager applet..."
_isRunning nm-applet || nm-applet >>$LOG_FILE 2>&1 &

# echo "Starting unclutter (hide mouse cursor when idle)..."
_isRunning unclutter || unclutter --timeout 5 --hide-on-touch -b &

# echo "Starting lxpolkit..." >> $LOG_FILE 2>&1
# _isRunning lxpolkit || /usr/bin/lxpolkit >> $LOG_FILE 2>&1 &

# echo "Starting clippy (clipboard daemon)..." >> $LOG_FILE 2>&1
supervisord -n -c $HOME/clippy.supervisor.conf >>$LOG_FILE 2>&1 &

# echo "Reloading wallpaper..." >> $LOG_FILE 2>&1
/storage/src/dot_files/tiling-window-managers/scripts/reload_wallpaper.sh >>$LOG_FILE 2>&1 &

# start polybar
/storage/src/dot_files/tiling-window-managers/scripts/polybar-launch.sh

if [[ $HOSTNAME == "mobpi" ]]; then
    SXHKD_CONFIG=/storage/src/dot_files/tiling-window-managers/sxhkd/sxhkdrc.mobpi
else
    SXHKD_CONFIG=/storage/src/dot_files/tiling-window-managers/sxhkd/sxhkdrc
fi
echo "Configuring sxhkd: $SXHKD_CONFIG..."
_isRunning sxhkd || sxhkd -c $SXHKD_CONFIG >>$LOG_FILE 2>&1 &

# echo "Running dunst..." >> $LOG_FILE 2>&1
nohup /storage/src/dot_files/tiling-window-managers/scripts/start-dunst.sh >>$LOG_FILE 2>&1 &

# echo "Reloading wal theme..." >> $LOG_FILE 2>&1
# wal-reload-last-theme.sh >> $LOG_FILE 2>&1 &

# TODO: setup and install trayer-ng, so that I can use the same network manager applet as lxde

# TODO: if there is a way to hide all windows and show the desktop, use conky do display some information on the desktop:
# $HOME/.Conky/startconky.sh >> $LOG_FILE 2>&1 &

# TODO: run battery_wall script below as a systemd user timer:
# $HOME/apps/scripts/bin/battery_wallpaper/battery_wall.py >> $LOG_FILE 2>&1 &
