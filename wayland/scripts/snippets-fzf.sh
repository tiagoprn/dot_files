#!/usr/bin/env bash

SNIPS=/storage/src/dot_files/text_snippets

# Use fzf in a floating terminal with preview
FILE=$(ghostty \
    --class="snippet-selector" \
    --title="Snippet Selector" \
    -e bash -c "
        cd '$SNIPS' && \
        ls | fzf \
            --prompt='Select snippet: ' \
            --preview='
                if [ -x \"$SNIPS/{}\" ]; then
                    echo \"[Executable script - preview of first 20 lines]\"
                    echo \"\"
                    head -20 \"$SNIPS/{}\"
                else
                    cat \"$SNIPS/{}\"
                fi
            ' \
            --preview-window=right:60%:wrap \
            --height=80% \
            --border \
            --info=inline
    ")

if [ -n "$FILE" ] && [ -f "$SNIPS/$FILE" ]; then
    DATA=$([ -x "$SNIPS/$FILE" ] && bash "$SNIPS/$FILE" || head --bytes=-1 "$SNIPS/$FILE")
    printf "$DATA" | ydotool type --file -
fi
