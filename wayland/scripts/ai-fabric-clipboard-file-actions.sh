#!/usr/bin/env bash

ACTION=$(echo -e 'summarize\ncustom_spell_check\nrewrite_text' | fzf --prompt 'Choose a fabric ai pattern: ')

cat /tmp/clipboard/copied.txt | fabric-ai -p "$ACTION" >/tmp/clipboard/ai.txt && nvim -o /tmp/clipboard/copied.txt /tmp/clipboard/ai.txt
