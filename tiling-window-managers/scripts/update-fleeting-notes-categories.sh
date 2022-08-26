#!/usr/bin/env bash

CATEGORIES_FILE="/storage/src/fleeting-notes/CATEGORIES.md"
DEFAULT_DATE="modified: 2022-01-01T00:00:00-03:00"

truncate -s 0 $CATEGORIES_FILE

echo -e "---\n$DEFAULT_DATE\n---\n" >$CATEGORIES_FILE

rg '^- [A-Z]+:' /storage/docs/fleeting-notes | awk '{print $2}' | sort | uniq >>$CATEGORIES_FILE
