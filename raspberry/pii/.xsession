# ---
# Autostart Programs
# ---

LOG_FILE=/tmp/xprofile.$(date +%Y-%m-%d).log

# TODO: turn picom below on a shellscript that toggles compositing on and off.
echo "Starting picom..." >> $LOG_FILE 2>&1
picom --config ~/picom.conf --backend glx >> $LOG_FILE 2>&1 &

echo "Starting lxpolkit..." >> $LOG_FILE 2>&1
/usr/bin/lxpolkit >> $LOG_FILE 2>&1 &

echo "Starting clippy (clipboard daemon)..." >> $LOG_FILE 2>&1
/home/pi/apps/scripts/bin/clippy.py >> $LOG_FILE 2>&1 &

# TODO: setup and install trayer-ng, so that I can use the same network manager applet as lxde

# TODO: if there is a way to hide all windows and show the desktop, use conky do display some information on the desktop:
# $HOME/.Conky/startconky.sh >> $LOG_FILE 2>&1 &

# TODO: maybe use polybar as a bottom bar, since dwm does not provide one?
# $HOME/.config/polybar/launch.sh >> $LOG_FILE 2>&1 &

# TODO: run battery_wall script below as a systemd user timer:
# $HOME/apps/scripts/bin/battery_wallpaper/battery_wall.py >> $LOG_FILE 2>&1 &

