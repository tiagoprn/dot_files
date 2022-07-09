#!/usr/bin/env bash

# This runs a terminal timer that counts down to zero
# from a specified amount of minutes and then
# lets the window manager draw attention to it in it's native way.

# based on script and explanation from: https://erikwinter.nl/notes/2020/basic-pomodoro-timer-in-bash-with-termdown-and-wmctrl/

# keywords: pomodoro, timer, stopwatch, wmctrl

set -eou pipefail

usage()
{
	echo "usage: pomodoro.sh -t [normal/break]"
}

no_args="true"
while getopts ":t:" arg; do
  case $arg in
    t) TYPE=$OPTARG;;
  esac
  no_args="false"
done

[[ "$no_args" == "true" ]] && { usage; exit 1; }

if [ "$TYPE" == 'normal' ]; then
	MINUTES=25
elif [ "$TYPE" == 'break' ]; then
	MINUTES=5
else
    echo -e 'UNKNOWN TYPE. :( \nKnown types are: normal, break.'
    exit 1
fi

# wmctrl handles the part of drawing the attention.
# The trick here is to make sure that attention is drawn to the right window.
# This is done setting the window title of the active window, the one we run the script in, to something known beforehand.
# This way, we can find it back later at the end of the countdown:
#
# -N "Pomodoro" sets the title of the window to "Pomodoro".
# -r :ACTIVE: selects the currently active window.
wmctrl -N "Pomodoro" -r :ACTIVE:

# below sets the timer
termdown --no-seconds -B --font univers -b -q 5 -t 'TIME IS UP!' ${MINUTES}m

# After the countdown, we let wmctrl draw the attention:
# -b add,demands_attention adds the property demands_attention to the window.
# -r "Pomodoro" selects the window that has "Pomodoro" as title.
wmctrl -b add,demands_attention -r "Pomodoro"
