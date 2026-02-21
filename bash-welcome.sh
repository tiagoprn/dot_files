#!/usr/bin/env bash

set -eou pipefail

# Define color variables
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e 'TMUX GOODIES:'

# is not inside tmux:
if [ -z "${TMUX+set}" ]; then
    echo -e "- Open ${YELLOW}tmuxp available sessions${NC} with the ${YELLOW}tp${NC} bash alias. (e.g. REMOTE)"
fi

echo -e "- Use ${YELLOW}tmux-ide.sh${NC} to create an ide session ${YELLOW}in the current directory${NC}."
echo -e "- Use ${YELLOW}dots.sh${NC} to create tmux sessions to all my config repos "
echo -e "  (${YELLOW}dot_files, devops, pde.nvim & nix-home-manager${NC})."

echo -e "-------------------------------------------------------------------------------------------------------------------------------"
echo -e "==> To get password from ${YELLOW}pass${NC}, use the ${YELLOW}gp${NC} bash alias <=="
echo -e "==> To open tmux ${YELLOW}mindshards & codex & reminders${NC}, use the ${YELLOW}hi${NC} bash alias <=="
echo -e "==> To ${YELLOW}edit local file clipboard${NC}, use the ${YELLOW}cf${NC} bash alias<=="
echo -e "==> To ${YELLOW}restart tars remotely${NC}, use the ${YELLOW}rt${NC} bash alias<=="
echo -e "==> Before running the ${GREEN}pi coding agent${NC} on a ${GREEN}non-git directory${NC}, use the ${GREEN}cds${NC} bash alias<=="
echo -e "-------------------------------------------------------------------------------------------------------------------------------"
echo -e ""
