#!/bin/bash

# Ask for the window name or part of it
echo "Enter the window name or part of it:"
read window_name

# Use xdotool to get the window ID using the window name
window_id=$(xdotool search --name "$window_name")

# Check if the window ID was found
if [ -z "$window_id" ]; then
    echo "Window not found."
    exit 1
fi

# Use xdotool to get the window geometry
window_info=$(xdotool getwindowgeometry "$window_id")

# Extract the position, width, and height from the window geometry
position=$(echo "$window_info" | awk '/Position:/ {print $2}')
width=$(echo "$window_info" | awk '/Geometry:/ {print $2}' | cut -d'x' -f1)
height=$(echo "$window_info" | awk '/Geometry:/ {print $2}' | cut -d'x' -f2)

# Check if position, width, and height were extracted successfully
if [ -z "$position" ] || [ -z "$width" ] || [ -z "$height" ]; then
    echo "Failed to get window geometry."
    exit 1
fi

# Extract the X and Y position from the position string
position_x=$(echo "$position" | cut -d',' -f1)
position_y=$(echo "$position" | cut -d',' -f2)

OUTPUT_DIR=/media/XTORAGE-2TB/TO-BE-MOVED/ffmpeg-captures

TIMESTAMP="$(date "+%Y%m%d-%H%M-%S")"

OUTPUT_FILE_NAME="$OUTPUT_DIR/$TIMESTAMP.mp4"

# Run the ffmpeg command with the window geometry
ffmpeg -f x11grab -s "$width"x"$height" -i "$DISPLAY"+"$position_x","$position_y" -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k $OUTPUT_FILE_NAME
