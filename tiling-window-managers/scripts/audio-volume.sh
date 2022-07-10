#!/bin/bash

set -eou pipefail

SCRIPT_NAME=$(basename "$0")

usage() {
    echo -e "usage: $SCRIPT_NAME -a value \n values:inc,dec"
}

no_args="true"
while getopts ":a:" arg; do
    case $arg in
        a) VALUE=$OPTARG ;;
        *) echo "invalid parameter" && {
            usage
            exit 1
        } ;;
    esac
    no_args="false"
done

[[ $no_args == "true" ]] && {
    usage
    exit 1
}

echo -e "VALUE=$VALUE"

if [ "$VALUE" == 'inc' ]; then
    echo 'will INCREASE'
    if [[ $HOSTNAME == cosmos ]]; then
        # below is because it uses pipewire with pulseaudio
        pactl set-sink-volume "$(pactl list short sinks | awk '{print $1}')" +5%
    else
        pactl set-sink-volume $(pacmd list-sinks | grep index | grep '*' | sed 's/: /:/g' | cut -d ':' -f 2) +5%
    fi
elif [ "$VALUE" == 'dec' ]; then
    echo 'will DECREASE'
    if [[ $HOSTNAME == cosmos ]]; then
        # below is because it uses pipewire with pulseaudio
        pactl set-sink-volume "$(pactl list short sinks | awk '{print $1}')" -5%
    else
        pactl set-sink-volume $(pacmd list-sinks | grep index | grep '*' | sed 's/: /:/g' | cut -d ':' -f 2) -5%
    fi
else
    echo 'unsupported action. Supported: inc or dec.'
    exit 1
fi
