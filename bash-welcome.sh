#!/usr/bin/env bash

set -eou pipefail

# Define color variables
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
BOLD_GREEN='\033[1;32m'
NC='\033[0m' # No Color

clear && reset

echo -e "==============================================================================================================================="
echo -e "                                               WELCOME TO $(hostname)!"
echo -e "==============================================================================================================================="
# if we are not inside tmux:
if [ -z "${TMUX+set}" ]; then
    echo -e "==> Open ${GREEN}tmuxp available sessions${NC} with the ${GREEN}tp${NC} bash alias. (e.g. REMOTE)"
else
    echo -e '==> TMUX GOODIES:'
    echo -e "    - Use ${YELLOW}ide${NC} to create a tmux ide session ${YELLOW}in the current directory${NC}."
    echo -e "    - Use ${YELLOW}dots${NC} to create tmux sessions to all my config repos (${YELLOW}dot_files, pde.nvim, etc${NC})."
    echo -e "    - To open tmux ${YELLOW}mindshards & codex & reminders${NC}, use the ${YELLOW}hi${NC} bash alias "
fi

echo -e "==> To get password from ${YELLOW}pass${NC}, use the ${YELLOW}gp${NC} bash alias "
echo -e "==> To ${YELLOW}edit local file clipboard${NC}, use the ${YELLOW}cf${NC} bash alias"
echo -e "==> Before running the ${BOLD_GREEN}pi coding agent${NC} on a ${BOLD_GREEN}non-git directory${NC}, use the ${BOLD_GREEN}cds${NC} bash alias"
echo -e "==> To ${BOLD_GREEN}search today reminders${NC}, use the ${BOLD_GREEN}rmd${NC} bash alias"
echo -e "==> To ${BOLD_GREEN}open pi coding agent config and session${NC}, use the ${BOLD_GREEN}tng${NC} bash alias"
echo -e "==> To ${BOLD_GREEN}update all my storage config repos (dot_files, devops, etc..)${NC}, run ${BOLD_GREEN} storage-repos-update.sh${NC}"
echo -e "==============================================================================================================================="
echo -e ""
