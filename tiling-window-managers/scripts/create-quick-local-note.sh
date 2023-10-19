#!/bin/bash

# based on: https://www.youtube.com/watch?v=zB_3FIGRWRU&feature=youtu.be

shopt -s expand_aliases
source $HOME/.bashrc

# OLD BASH ALIAS:
# alias j='nvim +"normal Go" +"normal Go---" +"r!date" $JOURNAL_FILE +"normal!G2o" +"startinsert"'

OUTPUT_FILE="$JOURNAL_FILE"
# OUTPUT_FILE="/tmp/test.txt"

cat <<. >>$OUTPUT_FILE

---
# $(date)
.

nvimai "$OUTPUT_FILE" +"normal!G2o" +"startinsert"
