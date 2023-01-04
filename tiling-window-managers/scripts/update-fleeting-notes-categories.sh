#!/usr/bin/env bash

CATEGORIES_FILE="/storage/src/fleeting-notes/CATEGORIES.md"
DEFAULT_DATE="modified: $(date '+%Y-%m-%dT%H:%M:%S')"

truncate -s 0 $CATEGORIES_FILE

echo -e "---\n$DEFAULT_DATE\n---\n" >$CATEGORIES_FILE

rg '^- [A-Z]+:' /storage/docs/fleeting-notes | awk '{print $2}' | sort | uniq >>$CATEGORIES_FILE
