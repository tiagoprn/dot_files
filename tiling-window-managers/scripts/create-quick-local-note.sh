#!/bin/bash

# based on: https://www.youtube.com/watch?v=zB_3FIGRWRU&feature=youtu.be

# OLD BASH ALIAS:
# alias j='nvim +"normal Go" +"normal Go---" +"r!date" $JOURNAL_FILE +"normal!G2o" +"startinsert"'

OUTPUT_FILE="$JOURNAL_FILE"
# OUTPUT_FILE="/tmp/test.txt"

cat <<. >>$OUTPUT_FILE

---
# $(date)
.

nvim "$OUTPUT_FILE" +"normal!G2o" +"startinsert"
