#!/usr/bin/env bash

set -eou pipefail

TEXT1=$(cat $HOME/.bash_functions | grep -e '^function ' | sed 's/function/(bash-function):/g' | sed 's/()/:/g' | sed 's/{  # //g' | sort | column -t -s ':')

TEXT2=$(cat $HOME/.bash_aliases | grep -e '^alias' | sed 's/#/HASH_CHARACTER/g' | sed 's/^alias/(bash-alias)##/g' | sed "s/\='/##/g" | sed 's/HASH_CHARACTER//g' | sed "s/'$//g" | sort | column -t -s '##')

TEXT3=""
if [ -f "$HOME/bashrc.custom" ]; then
    notify-send "found!!!"
    TEXT3=$(cat $HOME/bashrc.custom | grep -e '^alias' | sed 's/#/HASH_CHARACTER/g' | sed 's/^alias/(bash-alias)##/g' | sed "s/\='/##/g" | sed 's/HASH_CHARACTER//g' | sed "s/'$//g" | sort | column -t -s '##')
fi

# echo "$TEXT1\n$TEXT2" | dmenu -fn Mono:size=12 -c -bw 2 -l 20 -p 'Filter a bash function or alias'
# echo "$TEXT1\n$TEXT2" | rofi -dmenu -font 'Iosevka Regular 12' -p 'Filter a bash function or alias'
echo -e "$TEXT1\n$TEXT2\n$TEXT3" | sort | rofi -dmenu -p 'Filter a bash function or alias'
