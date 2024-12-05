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
    echo -e '- Consider opening tmuxp available sessions with the "tp" bash alias. (e.g. REMOTE)'
fi

echo -e '- Use "tn" or "tmux-nvim-project-setup.sh" to create a default session on a git repository'
echo -e '  with nvim, gitui and a scratchpad.'

# if [[ $HOSTNAME == cosmos ]]; then
#     echo -e '- To run timeshift: sudo timeshift-gtk'
# fi

echo -e "-----"
echo -e "==> To get password from ${RED}pass${NC}, use the ${RED}gp${NC} bash alias <=="
echo -e "==> To call ${RED}navi${NC}, use ${RED}<CTRL+G>${NC} when on INSERT mode. <=="
