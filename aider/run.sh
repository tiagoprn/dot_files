#!/usr/bin/env bash

set -eou pipefail

shopt -s expand_aliases

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
    --config /storage/src/dot_files/aider/conf.yaml
    --read /storage/src/ai-prompts/_persona.md
)

# FLAG TO DETERMINE IF WE ARE RESTORING A SESSION
restore_session=false

if [[ $user_response_lower == "y" || $user_response_lower == "yes" ]]; then
    # USE THE NAME SELECTED TO SET THE SESSION FILE NAMES

    selected_aider_session=$(extract_unique_prefixes | fzf)
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

# Initial fzf selection for the main prompt file
echo "Executing initial fzf selection..."
initial_selection=$(echo -e '/storage/src/ai-prompts/_system_natural_language.md\n/storage/src/ai-prompts/_system_code.md' | fzf --prompt "Select initial prompt file: ")
echo "Initial selection: '$initial_selection'"

# Check if initial selection was made
if [[ -z $initial_selection ]]; then
    echo "No initial prompt file selected. Exiting."
    exit 1
fi

# Add the selected initial prompt to aider_args
aider_args+=(--read "$initial_selection")

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

# Conditionally prompt for an additional --read file if the initial selection starts with "_system_code"
if [[ $initial_selection == *_system_code* ]]; then
    echo "Initial selection contains '_system_code'. Proceeding to find additional files."
    # Find other system_code.*.md files, excluding the already selected one
    # Construct a list of potential additional files
    potential_additional_files=$(find /storage/src/ai-prompts/ -maxdepth 1 -name "_system_code.*.md" -not -name "$(basename "$initial_selection")")
    echo "Potential additional files found: '$potential_additional_files'"

    if [[ -n $potential_additional_files ]]; then
        echo "Presenting fzf for additional file selection..."
        # Present these files for selection using fzf, allowing only one selection
        selected_additional_file=$(echo -e "$potential_additional_files" | fzf --prompt "Select ONE additional system code file (optional): ")
        echo "Selected additional file: '$selected_additional_file'"

        # If an additional file was selected, add it to aider_args
        if [[ -n $selected_additional_file ]]; then
            aider_args+=(--read "$selected_additional_file")
            echo "Added '$selected_additional_file' to aider_args."
        else
            echo "No additional file selected."
        fi
    else
        echo "No other system_code.*.md files found to present for selection."
    fi
else
    echo "Initial selection does not contain '_system_code'. Skipping additional file selection."
fi

echo "Constructed aider_args: ${aider_args[@]}"

# Execute aider with the constructed arguments
aider "${aider_args[@]}"
