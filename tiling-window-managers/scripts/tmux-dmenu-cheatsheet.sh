#!/bin/bash

BINDINGS=$(cat /storage/src/dot_files/.tmux.conf | grep '  #@ ' | sed 's/bind-key -T copy-mode-vi //g' | sed 's/bind-key -T root //g' | sed 's/bind-key //g' | sed 's/bind //g')

: '
Example output:

```
C-a send-prefix  #@ (TRIGGER PREFIX)                                                                                                                       │
Escape copy-mode  #@ enter copy mode                                                                                                                       │
v send-keys -X begin-selection  #@ (vim copy mode) begin selection                                                                                         │
y send-keys -X copy-selection-and-cancel  #@ (vim copy mode) copy selection                                                                                │
r send-keys -X rectangle-toggle  #@ (vim copy mode) begin vertical selection                                                                               │
Enter send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"  #@ (vim copy mode) copy selection to clipboard   │
PPage if-shell -F "#{alternate_on}" "send-keys PPage" "copy-mode -e; send-keys PPage"  #@ <PageUp/Down>: scroll back in history                            │
PPage send-keys -X page-up  #@ (vim copy mode) <PageUp>                                                                                                    │
y set-window-option synchronize-panes  #@ broadcast commands to all panes (like terminator does)                                                           │
/ split-window -h -c "#{pane_current_path}"  #@ new window, horizontal split                                                                               │
\ split-window -v -c "#{pane_current_path}"  #@ new window, vertical split                                                                                 │
r source-file ~/.tmux.conf \; display-message "Config reloaded!"  #@ reload tmux with current .tmux.conf                                                   │
```
'

echo -e "$BINDINGS" \
    | awk 'BEGIN { FS = "#@"} {word_end_index= match($1, " "); binding_text=substr($1, 0, word_end_index); print $2 " @ " binding_text}' \
    | column -t -s '@' \
    | sort \
    | dmenu -fn Monospace:size=12 -c -bw 2 -l 20 -p 'Filter a tmux binding:'

: '
Explaining the awk language expression:

BEGIN { FS = "#@"} {word_end_index= match($1, " "); binding_text=substr($1, 0, word_end_index); print $2 " @ " binding_text}
        |           |                               |                                           |
        |           |                               |                                           |--------- print the second part of the #@ split, plus the computed binding.
        |           |                               |
        |           |                               |--------- get a substring of the first part of the #@ split,
        |           |                                          from the start until the position of the first " ".
        |           |                                          That will give us the first word, which is the binding.
        |           |
        |           |--------- get the position of the first " " char on the first part of the #@ split.
        |
        |--------- defines the separator (FS) on each line of the file, to get the splits.
'
