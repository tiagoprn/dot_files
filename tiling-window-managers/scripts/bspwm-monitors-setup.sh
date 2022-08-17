#! /bin/bash

internal_monitor=eDP-1
external_monitor=HDMI-1

monitor_add() {
    notify-send "$(basename $0)" "Adding monitor..."
    desktops=4 # How many desktops to move to the second monitor

    for desktop in $(bspc query -D -m $internal_monitor | sed "$desktops"q); do
        bspc desktop $desktop --to-monitor $external_monitor
    done

    # Remove "Desktop" created by bspwm
    bspc desktop Desktop --remove
    # bspc monitor $internal_monitor --reset-desktops 1 2 3 4 &
    # bspc monitor $external_monitor --reset-desktops 5 6 7 8 &
}

monitor_remove() {
    notify-send "$(basename $0)" "Removing monitor..."
    bspc monitor $internal_monitor -a Desktop # Temp desktop because one desktop required per monitor

    # Move everything to external monitor to reorder desktops
    for desktop in $(bspc query -D -m $internal_monitor); do
        bspc desktop $desktop --to-monitor $external_monitor
    done

    # Now move everything back to internal monitor
    bspc monitor $external_monitor -a Desktop # Temp desktop

    for desktop in $(bspc query -D -m $external_monitor); do
        bspc desktop $desktop --to-monitor $internal_monitor
    done

    bspc desktop Desktop --remove # Remove temp desktops
    # bspc monitor $internal_monitor --reset-desktops 1 2 3 4 5 6 7 8 &
}

if [[ $(xrandr -q | grep 'HDMI-1 connected ' | grep '2560') ]]; then
    monitor_add
    # below is to the desktop indexes on polybar to match the right workspaces:
    first_monitor=$(bspc query -M --names | head -n 1)
    if [ "$first_monitor" == 'eDP-1' ]; then
        notify-send "$(basename $0)" "Adjusting monitor order..."
        bspc monitor HDMI-1 -s eDP-1
    fi

else
    monitor_remove
    autorandr -l undocked
fi

# start polybar
notify-send "$(basename $0)" "Restarting polybar..."
/storage/src/dot_files/tiling-window-managers/scripts/polybar-launch.sh &
