#!/bin/bash

read -r -d '' WRAPPER_INFO <<'EOL'
# --------------------------------------------------
# DEFAULT
# --------------------------------------------------
#
# This script launches the Aider AI coding assistant
# to be used with no specific purpose (default).
#
# Features:
# - Vim integration for seamless editing
# - File watching for automatic updates
# - Custom configuration and theming
# - Secure API key management via pass
#
# Usage: ./default-coding-python.sh [additional_args]
EOL

# Function to display help
show_help() {
    echo "$WRAPPER_INFO"
    echo -e "\n\nAdditional options:"
    echo "  -h, --help     Show this help message"
    echo "  -q, --quiet    Skip the intro messages and prompts"
    echo "  -v, --verbose  Enable verbose mode (see all the raw information being sent to/from the LLM in the conversation)"
    exit 0
}

# Default values
VERBOSE_MODE=false
ADDITIONAL_ARGS=()

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h | --help)
            show_help
            ;;
        -q | --quiet)
            QUIET_MODE=true
            shift
            ;;
        -v | --verbose)
            VERBOSE_MODE=true
            shift
            ;;
        *)
            ADDITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Build the command
CMD=("aider" "--vim" "--no-git")
CMD+=("--config" "/storage/src/dot_files/aider/conf.yaml")
CMD+=("--dark-mode" "--code-theme" "solarized-dark")
# 'system prompt' files you can use with more specific instructions. Add more of that "--read" param if you need to add more files to the context:
CMD+=("--read" "/storage/src/ai-prompts/_persona.md")

# Add verbose flags if requested
if [ "$VERBOSE_MODE" = true ]; then
    CMD+=("--verbose" "--no-pretty")
fi

# Add any additional arguments passed to the script
CMD+=("${ADDITIONAL_ARGS[@]}")

# Execute the command
"${CMD[@]}"
