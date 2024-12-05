#!/usr/bin/env bash

set -eou pipefail

# Define color variables
RED='\033[0;31m'
NC='\033[0m' # No Color

# if [ -d "/storage/src/fortunes/" ]; then
#     cowsay -b -f tux -W 80 $(fortune -u -e -c /storage/src/fortunes/ | tail +3)
# fi

echo -e 'TMUX GOODIES:'

# is not inside tmux:
if [ -z "${TMUX+set}" ]; then
    echo -e "- Open ${RED}tmuxp available sessions${NC} with the ${RED}tp${NC} bash alias. (e.g. REMOTE)"
fi

echo -e "- Use ${RED}tmux-ide.sh${NC} to create an ide session ${RED}in the current directory${NC}."

# if [[ $HOSTNAME == cosmos ]]; then
#     echo -e '- To run timeshift: sudo timeshift-gtk'
# fi

echo -e "-----"
echo -e "==> To get password from ${RED}pass${NC}, use the ${RED}gp${NC} bash alias <=="
echo -e "==> To call ${RED}navi${NC}, use ${RED}<CTRL+G>${NC} when on INSERT mode. <=="
echo -e "==> To open tmux ${RED}tasks, fleeting-notes & reminders${NC}, use the ${RED}hi${NC} bash alias <=="
echo -e "==> To ${RED}edit local file clipboard${NC}, use the ${RED}cf${NC} bash alias<=="
