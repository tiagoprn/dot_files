#!/bin/bash

set -eou pipefail

if [ -x "$(command -v tput)" ]; then
    BOLD="$(tput bold)"
    BLACK="$(tput setaf 0)"
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    MAGENTA="$(tput setaf 5)"
    CYAN="$(tput setaf 6)"
    WHITE="$(tput setaf 7)"
    COLOR_END="$(tput sgr0)"
fi

recent() {
    echo -e "\n${MAGENTA}# Branches${COLOR_END}"
    for k in $(git branch | perl -pe 's/^..(.*?)( ->.*)?$/\1/'); do
        echo -e $(git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset " $k -- | head -n 1)\\\t$k
    done | sort -r | head
    _num_stashes=$(git stash list | wc -l | while read l; do echo "$l - 1"; done | bc)
    echo -e "\n${MAGENTA}# Stashes${COLOR_END}"
    for i in $(seq 0 ${_num_stashes}); do
        echo -en "${CYAN}stash@{${i}}:${GREEN}" && git show --format="%ad%Creset %s" stash@{$i} | head -n 1
    done
}

recent
