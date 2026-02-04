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

# Build hierarchy of role directories from root to leaf
# e.g., for "development/linux_bash": ["development", "development/linux_bash"]
IFS='/' read -ra ROLE_PARTS <<<"$ROLE"
ROLE_HIERARCHY=()
CURRENT_PATH=""

for part in "${ROLE_PARTS[@]}"; do
    if [[ -z $CURRENT_PATH ]]; then
        CURRENT_PATH="$part"
    else
        CURRENT_PATH="$CURRENT_PATH/$part"
    fi
    ROLE_HIERARCHY+=("$CURRENT_PATH")
done

# Process each level in the hierarchy to include parent role files
for i in "${!ROLE_HIERARCHY[@]}"; do
    ROLE_DIR="$ROOT/roles/${ROLE_HIERARCHY[$i]}"
    [[ -d $ROLE_DIR ]] || continue

    # Parent dirs: maxdepth 1 (avoid recursing into child roles)
    # Leaf dir: unlimited depth (include all subdirectories of the selected role)
    if [[ $i -eq $((${#ROLE_HIERARCHY[@]} - 1)) ]]; then
        MAXDEPTH=""
    else
        MAXDEPTH="-maxdepth 1"
    fi

    # Find .md files, applying existing exclude filters
    find "$ROLE_DIR" $MAXDEPTH -type f -name "*.md" | while read f; do
        rel="${f#$ROOT/}"
        # Skip paths with "_" or ".sh"
        if [[ $rel =~ /_ || $rel =~ ^_ || $rel =~ \.sh$ ]]; then
            continue
        fi
        echo "$rel"
    done | sort | while read relpath; do
        echo "--- $relpath ---"
        cat "$ROOT/$relpath"
        echo ""
    done
done
