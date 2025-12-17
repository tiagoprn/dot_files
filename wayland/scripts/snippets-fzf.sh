#!/usr/bin/env bash
set -euo pipefail

SNIPS=/storage/src/dot_files/text_snippets

FILE=$(fd -t f -a . "$SNIPS" | tv --preview-size 65 --preview-command 'bat -n --color=always {}')
status=$?

if [ $status -ne 0 ] || [ -z "${FILE:-}" ]; then
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "Error: File not found: $FILE" >&2
    exit 1
fi

if [ -x "$FILE" ]; then
    DATA=$(bash "$FILE")
else
    DATA=$(head --bytes=-1 "$FILE")
fi

if [ -z "${DATA:-}" ]; then
    exit 1
fi

# Strip one trailing newline if present
DATA="${DATA%$'\n'}"

# Optionally also strip a trailing carriage return (for CRLF files)
DATA="${DATA%$'\r'}"

printf '%s' "$DATA" >/tmp/clipboard/copied.txt

notify-send -t 5000 "🤖 Snippet successfully processed and copied to clipboard! Now, paste it where you need. 📋"

exit 0
