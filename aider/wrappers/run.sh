#!/usr/bin/env bash

set -eou pipefail

shopt -s expand_aliases

base_dir="$HOME/.local/aider-sessions"
mkdir -p "$base_dir"

# Get full current directory and turn / into _
cwd=$(pwd)
safe_cwd=$(printf "%s" "$cwd" | sed "s|/|_|g")

ts=$(date "+%Y%m%d_%H%M%S")

chat_file="${base_dir}/${safe_cwd}.${ts}.chat.md"
input_file="${base_dir}/${safe_cwd}.${ts}.input.md"
llm_file="${base_dir}/${safe_cwd}.${ts}.llm.log"

aider \
    --chat-history-file "$chat_file" \
    --input-history-file "$input_file" \
    --llm-history-file "$llm_file" \
    --no-git \
    --config /storage/src/dot_files/aider/conf.yaml \
    --read /storage/src/ai-prompts/_persona.md \
    --read "$(echo -e '/storage/src/ai-prompts/_system_natural_language.md\n/storage/src/ai-prompts/_system_code.md' | fzf)"
