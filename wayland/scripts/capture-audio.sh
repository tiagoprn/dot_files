#!/usr/bin/env bash
# This script leverages pipewire capabilities to create a new audio source merging the system (desktop) audio and the microphone into a new source named "VirtualSink"

set -eou pipefail

# list desktop audio (output) sources that can be recorded
DESKTOP_AUDIO_SOURCE=$(pactl list sources short | grep 'alsa_output' | grep '.monitor' | fzf --prompt 'Choose a desktop audio OUTPUT source (PHONE, HEADSET): ' | awk '{print $2}')
echo "Selected Desktop Audio Source: $DESKTOP_AUDIO_SOURCE"

# list microphone (input) sources that can be recorded
MICROPHONE_AUDIO_SOURCE=$(pactl list sources short | grep 'alsa_input' | fzf --prompt 'Choose an INPUT source (MICROPHONE): ' | awk '{print $2}')
echo "Selected Microphone Audio Source: $MICROPHONE_AUDIO_SOURCE"

echo 'Creating virtual sink...'
VIRTUAL_SINK_MODULE_ID=$(pactl load-module module-null-sink sink_name="VirtualSink" sink_properties=device.description="Virtual Sink")
echo "Virtual sink module ID: $VIRTUAL_SINK_MODULE_ID"

if [ -n "$VIRTUAL_SINK_MODULE_ID" ] && [ "$VIRTUAL_SINK_MODULE_ID" != "Failure: Invalid argument" ]; then
    echo 'Looping back microphone audio to virtual sink...'
    MIC_LOOPBACK_MODULE_ID=$(pactl load-module module-loopback source="$MICROPHONE_AUDIO_SOURCE" sink=VirtualSink rate=48000 adjust_time=0)
    echo "Microphone loopback module ID: $MIC_LOOPBACK_MODULE_ID"

    echo 'Looping back system (desktop) audio to virtual sink...'
    DESK_LOOPBACK_MODULE_ID=$(pactl load-module module-loopback source="$DESKTOP_AUDIO_SOURCE" sink=VirtualSink rate=48000 adjust_time=0)
    echo "Desktop audio loopback module ID: $DESK_LOOPBACK_MODULE_ID"
else
    echo "Error creating virtual sink, check the arguments or module availability."
fi

echo -e "\n---\nFINISHED! To delete the modules, search for 'pipewire' on navi."
