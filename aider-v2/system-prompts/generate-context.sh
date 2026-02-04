#!/usr/bin/env bash

# This script produces a single markdown file inlining PERSONA.md,
# all root-level files (except those starting with "_" or having a ".sh" extension),
# and every file related to one specific role (also skipping any file/dir whose name
# starts with "_" or has ".sh" extension). The role is selected interactively using fzf.
# Each file's contents are preceded by a header line in the form "--- relative/path ---".
#
# Usage:
#   ./make_role_markdown.sh
# - After running, you'll be prompted to pick a role using fzf.
# - Output is written to stdout; redirect as needed.
#
# Examples:
#   ./make_role_markdown.sh > all-selected-role.md
#
# - $ROOT is the top-level directory of your system-prompts tree.
# - This enables you to pick all files relevant to one role,
#   generate distinct base files, and use them as the starting
#   point for agent prompts or further processing.
# - Files/directories starting with "_" or ending with ".sh" are excluded.

ROOT="/storage/src/dot_files/aider-v2/system-prompts"

# Role selection via fzf
if ! command -v fzf >/dev/null; then
    echo "fzf is required for role selection. Please install fzf and try again."
    exit 1
fi

ROLE=$(printf "development/linux_bash\ndevelopment/neovim_lua\ndevelopment/python\nnatural_language\netc" | fzf --prompt="Select role: ")

if [[ -z $ROLE ]]; then
    echo "No role selected. Exiting."
    exit 1
fi

# Print PERSONA.md if present
if [[ -f "$ROOT/PERSONA.md" ]]; then
    echo "--- PERSONA.md ---"
    cat "$ROOT/PERSONA.md"
    echo ""
fi

# Print all root-level files not starting with "_" or ".sh", and not PERSONA.md
find "$ROOT" -maxdepth 1 -type f ! -name "PERSONA.md" \
    | while read file; do
        fname="${file#$ROOT/}"
        if [[ ! $fname =~ ^_ && ! $fname =~ \.sh$ ]]; then
            echo "--- $fname ---"
            cat "$file"
            echo ""
        fi
    done

# Function to find all files under $1, skipping any with "/_" or ".sh" in their path
find_filtered_files() {
    find "$1" -type f | while read f; do
        rel="${f#$ROOT/}"
        # Exclude if any file/dir component starts with "_" or ends with ".sh"
        if [[ $rel =~ /_ || $rel =~ ^_ || $rel =~ \.sh$ ]]; then
            continue
        fi
        echo "$rel"
    done | sort
}

# Print all files under roles/$ROLE, skipping any with "_" or ".sh" at any path segment
ROLE_DIR="$ROOT/roles/$ROLE"
if [[ -d $ROLE_DIR ]]; then
    find_filtered_files "$ROLE_DIR" | while read relpath; do
        echo "--- $relpath ---"
        cat "$ROOT/$relpath"
        echo ""
    done
fi
