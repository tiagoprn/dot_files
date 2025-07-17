#!/usr/bin/env bash

# Check for required dependencies
command -v slurp >/dev/null 2>&1 || {
    notify-send "Error" "slurp not found. Please install it."
    exit 1
}
command -v wf-recorder >/dev/null 2>&1 || {
    notify-send "Error" "wf-recorder not found. Please install it."
    exit 1
}
command -v ffmpeg >/dev/null 2>&1 || {
    notify-send "Error" "ffmpeg not found. Please install it."
    exit 1
}
command -v zenity >/dev/null 2>&1 || {
    notify-send "Error" "zenity not found. Please install it."
    exit 1
}

# Prompt for duration if not provided
if [ $# -eq 0 ]; then
    DURATION=$(zenity --entry \
        --title="Screen Recording" \
        --text="Enter recording duration in seconds:" \
        --entry-text="30")

    # Check if user cancelled or entered empty value
    if [ $? -ne 0 ] || [ -z "$DURATION" ]; then
        notify-send "Recording cancelled"
        exit 1
    fi

    # Validate that input is a number
    if ! [[ $DURATION =~ ^[0-9]+$ ]]; then
        zenity --error --text="Invalid duration. Please enter a number."
        exit 1
    fi
else
    DURATION=$1
fi

GEOMETRY=$(slurp)

if [ -n "$GEOMETRY" ]; then
    mkdir -p "$HOME/Videos/tmp"
    TEMP_FILE="$HOME/Videos/tmp/temp_recording_$(date +%s).mkv"
    FINAL_FILE="$HOME/Videos/$(date +'%Y-%m-%d_%H-%M-%S').webm"

    # Create Videos directory if it doesn't exist
    mkdir -p "$HOME/Videos"

    # Show recording notification
    notify-send "Screen Recording" "Recording for $DURATION seconds..."

    # Record the screen with timeout
    timeout "$DURATION" wf-recorder -g "$GEOMETRY" -c libx264 -r 30 -f "$TEMP_FILE"
    TIMEOUT_EXIT_CODE=$?

    # Check if recording was successful
    # timeout returns 124 when it times out (which is expected)
    # timeout returns 0 if command completes normally before timeout
    # Other exit codes indicate actual errors
    if [ $TIMEOUT_EXIT_CODE -ne 124 ] && [ $TIMEOUT_EXIT_CODE -ne 0 ]; then
        notify-send "Error" "Recording failed with exit code $TIMEOUT_EXIT_CODE"
        exit 1
    fi

    if [ ! -f "$TEMP_FILE" ]; then
        notify-send "Error" "Recording failed - no output file created!"
        exit 1
    fi

    # Show processing notification
    notify-send "Processing" "Converting to WebM (Pass 1/2)..."

    # First pass
    ffmpeg -i "$TEMP_FILE" \
        -c:v libvpx-vp9 -crf 20 -b:v 0 -pass 1 -speed 4 \
        -tile-columns 6 -frame-parallel 1 -threads 8 -row-mt 1 \
        -f null /dev/null 2>/dev/null

    # Check if first pass was successful
    if [ $? -ne 0 ]; then
        notify-send "Error" "First encoding pass failed!"
        rm -f "$TEMP_FILE"
        exit 1
    fi

    # Show second pass notification
    notify-send "Processing" "Converting to WebM (Pass 2/2)..."

    # Second pass
    ffmpeg -i "$TEMP_FILE" \
        -c:v libvpx-vp9 -crf 20 -b:v 0 -pass 2 -speed 1 \
        -tile-columns 6 -frame-parallel 1 -threads 8 -row-mt 1 \
        -c:a libopus -b:a 128k \
        "$FINAL_FILE" 2>/dev/null

    # Check if second pass was successful
    if [ $? -ne 0 ]; then
        notify-send "Error" "Second encoding pass failed!"
        rm -f "$TEMP_FILE"
        exit 1
    fi

    # Clean up temporary file
    rm -f "$TEMP_FILE"

    # Clean up ffmpeg log files
    rm -f ffmpeg2pass-0.log ffmpeg2pass-0.log.mbtree

    # Get file size and show completion notification
    if [ -f "$FINAL_FILE" ]; then
        FILE_SIZE=$(du -h "$FINAL_FILE" | cut -f1)
        FILENAME=$(basename "$FINAL_FILE")
        notify-send "Recording Complete!" "Saved: $FILENAME\nSize: $FILE_SIZE\nLocation: ~/Videos/"
        echo "Optimized recording saved to: $FINAL_FILE (Size: $FILE_SIZE)"
    else
        notify-send "Error" "Final file was not created!"
        exit 1
    fi
else
    notify-send "Recording Cancelled" "No region selected"
    echo "No region selected"
fi
