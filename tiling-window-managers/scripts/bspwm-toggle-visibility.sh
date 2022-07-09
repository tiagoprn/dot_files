#!/bin/bash

# reference: https://my-take-on.tech/2020/07/03/some-tricks-for-sxhkd-and-bspwm/#easily-order-windows

# In short, this script takes a process name (which is a class name or instance name, obtainable by xprop) and searches for it. Then, it applies a rule based on its status:
# Status 			Rule
# ------			____
# Non-existent 		Launch
# Visible 		Hide
# Hidden 			Show

# Sometimes a process name will differ from its executable, so there’s also an option to specify an executable name.

# Also, some programs will spawn multiple instances, while only the first one actually matters, so it implements a --take-first switcher to apply the show/hide only on the first instance of that program.


if [ $# = 0 ]; then
    cat <<EOF
Usage: $(basename "${0}") process_name [executable_name] [--take-first]
    process_name       As recognized by 'xdo' command
    executable_name    As used for launching from terminal
    --take-first       In case 'xdo' returns multiple process IDs
EOF
    exit 0
fi

# Get id of process by class name and then fallback to instance name
id=$(xdo id -N "${1}" || xdo id -n "${1}")

executable=${1}
shift

while [ -n "${1}" ]; do
    case ${1} in
    --take-first)
        id=$(head -1 <<<"${id}" | cut -f1 -d' ')
        ;;
    *)
        executable=${1}
        ;;
    esac
    shift
done

if [ -z "${id}" ]; then
    ${executable}
else
    while read -r instance; do
        bspc node "${instance}" --flag hidden --to-monitor focused --focus -t floating
    done <<<"${id}"
fi
