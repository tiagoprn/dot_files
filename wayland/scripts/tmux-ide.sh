#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Optional: Enable debugging by uncommenting the next line
# set -x

# Get the base name of the current directory to use as the session name
SESSION_NAME=$(basename "$PWD")

# Replace any '.' in the session name with '_'
SESSION_NAME=${SESSION_NAME//./_}

# Path to the git shell script
GIT_SCRIPT="/storage/src/dot_files/git-ui-with-ssh-agent.sh"

# Log file path (optional)
LOGFILE="$HOME/tmux-ide.log"

# Redirect all output to the log file (optional)
# Uncomment the following lines to enable logging
# exec > >(tee -i "$LOGFILE") 2>&1
# echo "Starting tmux-ide.sh at $(date)"

# Function to print error messages to stderr
error() {
    echo "Error: $1" >&2
}

# Check if tmux is installed
if ! command -v tmux &>/dev/null; then
    error "tmux is not installed. Please install tmux and try again."
    exit 1
fi

# Check if the git script exists and is executable
if [[ ! -x $GIT_SCRIPT ]]; then
    error "Git script '$GIT_SCRIPT' does not exist or is not executable."
    exit 1
fi

# Function to create a new tmux session with the required windows
create_tmux_session() {
    # Start a new detached tmux session named "$SESSION_NAME" without running any command
    tmux new-session -d -s "$SESSION_NAME" -n ""

    # Set the base-index to 1 for window numbering (session option)
    tmux set-option -t "$SESSION_NAME" base-index 1

    # Rename the initial window to "nvim" and run 'nvim'
    tmux rename-window -t "$SESSION_NAME":1 "nvim"
    # Set pane-base-index to 1 for the "nvim" window
    tmux set-option -w -t "${SESSION_NAME}:nvim" pane-base-index 1
    tmux send-keys -t "${SESSION_NAME}:nvim.1" "nvim" C-m

    # Create the second window named "git" and run the specified shell script
    tmux new-window -t "$SESSION_NAME" -n "git" "bash $GIT_SCRIPT ."
    # Set pane-base-index to 1 for the "git" window
    tmux set-option -w -t "${SESSION_NAME}:git" pane-base-index 1

    # Create the third window named "scratchpad"
    tmux new-window -t "$SESSION_NAME" -n "scratchpad"
    # Set pane-base-index to 1 for the "scratchpad" window
    tmux set-option -w -t "${SESSION_NAME}:scratchpad" pane-base-index 1

    # Pause for 0.1 seconds to give time to the window to be created
    sleep 0.1

    # Send the message to the "scratchpad" window's first pane
    tmux send-keys -t "${SESSION_NAME}:scratchpad.1" "echo 'You can run a runserver or other commands on this pane'" C-m

    # Select the first window ("nvim")
    tmux select-window -t "${SESSION_NAME}:nvim"

    # Attach to the newly created session
    attach_to_session
}

# Function to attach or switch to an existing session
attach_to_session() {
    if [ -n "$TMUX" ]; then
        # Inside a tmux session: switch the current client to the desired session
        tmux switch-client -t "$SESSION_NAME"
    else
        # Outside a tmux session: attach to the desired session
        tmux attach-session -t "$SESSION_NAME"
    fi
}

# Check if a tmux session with the desired name already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    # Session exists: attach or switch to it
    attach_to_session
else
    # Session does not exist: create it with the specified windows
    create_tmux_session
fi
