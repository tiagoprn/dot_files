#!/usr/bin/env bash

# More info : https://github.com/jaagr/polybar/wiki

# Install the following applications for polybar and icons in polybar if you are on ArcoLinuxD
# awesome-terminal-fonts
# Tip : There are other interesting fonts that provide icons like nerd-fonts-complete
# --log=error
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

desktop=$(echo "$DESKTOP_SESSION")

monitors=$(xrandr --query | grep " connected" | cut -d" " -f1 | tr '\n' ' ')

total_monitors=$(echo "$monitors" | wc -l)

echo -e "TOTAL MONITORS DETECTED: $total_monitors\n\n"

declare -A MAPPINGS=(
    ['eDP-1']="mainbar-bspwm"
    ['HDMI-1']="mainbar-bspwm-wide"
)

notify-send "polybar-launch.sh" "$total monitors connected, configuring..."

if [[ $HOSTNAME == cosmos ]]; then
    if [ "$total_monitors" == 1 ]; then
        POLYBAR_CONFIG='/storage/src/dot_files/tiling-window-managers/polybar/config.cosmos.embedded-monitor'
    else
        POLYBAR_CONFIG='/storage/src/dot_files/tiling-window-managers/polybar/config.cosmos'
    fi
else
    POLYBAR_CONFIG='/storage/src/dot_files/tiling-window-managers/polybar/config'
fi

case $desktop in

    bspwm | /usr/share/xsessions/bspwm)

        for monitor in $monitors; do
            echo -e "$monitor"

            for key in "${!MAPPINGS[@]}"; do
                bar_name=${MAPPINGS[$key]}
                if [ "$key" == "$monitor" ]; then
                    notify-send "polybar-launch.sh" "configuring monitor $key with bar $bar_name..."
                    MONITOR="$monitor" polybar --reload "$bar_name" -c "$POLYBAR_CONFIG" &
                fi
            done

        done
        ;;

esac
