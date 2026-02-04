#!/usr/bin/env bash

set -eou pipefail

shopt -s expand_aliases

# Define color variables
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

clear

# First, let's choose the chat mode:
echo -e "${YELLOW}ABOUT CHAT MODES${NC}\n\n"
echo -e "${YELLOW}architect${NC} - uses ${YELLOW}2 models (MAIN + EDITOR)${NC}: use this to be able to use a main model to think and another to edit the files (recommended for handling code tasks)\n${YELLOW}ask${NC}: uses ${YELLOW}1 model (the MAIN model)${NC}: use this to ask questions\n\nThis can also be changed interactively on the chat with the command '/chat-mode [ask/code/architect]'\n\n"

read -p "Now, press Enter to move on and select one of these modes..."

# First, let's choose the chat mode:
CHAT_MODE=$(echo -e 'ask\narchitect' | fzf --prompt 'Choose a chat mode: ' | cut -d ' ' -f 1)

echo "$CHAT_MODE"

# Generate context

AIDER_CONF_ROOT="/storage/src/dot_files/aider-v2"

$AIDER_CONF_ROOT/system-prompts/generate-context.sh >/tmp/role.md

sessions_dir="$HOME/.local/aider-sessions"
mkdir -p "$sessions_dir"

extract_unique_prefixes() {

    # Example return:
    #   _storage_src_dot_files_aider_wrappers.20251207_082655
    #   _storage_src_dot_files.20251208_060124
    #   _storage_src_dot_files.20251207_085051
    #   _storage_src_dot_files.20251207_083243
    #   _home_tiago.20251207_080117

    find "$sessions_dir" -type f -print0 \
        | while IFS= read -r -d $'\0' file; do
            filename="${file##*/}" # strip path, keep just basename
            if [[ $filename =~ ^(.*\.[0-9]{8}_[0-9]{6})\..*$ ]]; then
                # Group 1 = prefix including .YYYYMMDD_HHMMSS
                echo "${BASH_REMATCH[1]}"
            fi
        done | sort -u
}

# Check if fzf is installed and available
if ! command -v fzf &>/dev/null; then
    echo "Error: fzf is not installed or not in your PATH." >&2
    echo "Please install fzf to use this script." >&2
    exit 1
fi

# Prompt the user with a yes/no question (default is no)
# The 'read' command with -p displays a prompt, and -r prevents backslash escapes.
# The default answer is 'n' if the user just presses Enter.
read -p "Do you want to continue an existing session? (y/N) " -r user_response

# Convert response to lowercase for easier comparison
user_response_lower=$(echo "$user_response" | tr '[:upper:]' '[:lower:]')

# Initialize aider_args with common arguments
aider_args=(
    --no-git
    --config "$AIDER_CONF_ROOT"/conf.yaml
    --read /tmp/role.md
    --chat-mode "$CHAT_MODE"
)

# FLAG TO DETERMINE IF WE ARE RESTORING A SESSION
restore_session=false

if [[ $user_response_lower == "y" || $user_response_lower == "yes" ]]; then
    # USE THE NAME SELECTED TO SET THE SESSION FILE NAMES
    selected_aider_session=$(
        extract_unique_prefixes \
            | FZF_DEFAULT_OPTS='' \
                fzf \
                --prompt='Select a session to restore: ' \
                --preview "bat --color=always --style=numbers -- ${sessions_dir}/{}.input.md" \
                --preview-window='right:60%:wrap'
    )

    fzf_exit_status=$?

    if [ $fzf_exit_status -eq 0 ]; then
        # A selection was made
        echo "You selected: $selected_aider_session"

        chat_file="${sessions_dir}/${selected_aider_session}.chat.md"
        input_file="${sessions_dir}/${selected_aider_session}.input.md"
        llm_file="${sessions_dir}/${selected_aider_session}.llm.log"

        # Set the flag to true as we are restoring a session
        restore_session=true

        # ls -lha "$chat_file"
        # ls -lha "$input_file"
        # ls -lha "$llm_file"

    elif [ $fzf_exit_status -eq 129 ]; then
        # fzf was cancelled (e.g., by pressing Esc)
        echo "No prefix selected. Operation cancelled."
        exit 1
    else
        # An unexpected error occurred with fzf
        echo "An unexpected error occurred with fzf (exit status: $fzf_exit_status)." >&2
        exit $fzf_exit_status
    fi

else
    # CREATE NEW FILES FOR THE SESSION

    # Get full current directory and turn / into _
    cwd=$(pwd)
    safe_cwd=$(printf "%s" "$cwd" | sed "s|/|_|g")
    ts=$(date "+%Y%m%d_%H%M%S")

    chat_file="${sessions_dir}/${safe_cwd}.${ts}.chat.md"
    input_file="${sessions_dir}/${safe_cwd}.${ts}.input.md"
    llm_file="${sessions_dir}/${safe_cwd}.${ts}.llm.log"
fi

echo -e "chat_file = $chat_file"
echo -e "input_file = $input_file"
echo -e "llm_file = $llm_file"

# Conditionally add restore arguments if restoring a session
if [[ $restore_session == true ]]; then
    aider_args+=(--restore)
    aider_args+=(--chat-history-file "$chat_file")
    aider_args+=(--input-history-file "$input_file")
    aider_args+=(--llm-history-file "$llm_file")
else
    # For new sessions, we still need to specify the files to create them
    aider_args+=(--chat-history-file "$chat_file")
    aider_args+=(--input-history-file "$input_file")
    aider_args+=(--llm-history-file "$llm_file")
fi

echo "Constructed aider_args: ${aider_args[@]}"

# Execute aider with the constructed arguments
aider "${aider_args[@]}"
