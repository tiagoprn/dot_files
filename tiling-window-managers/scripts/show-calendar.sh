#!/bin/bash

clear && echo "TODAY IS: $(date '+%A %d, %B %Y')" | cowthink && echo '' && ncal -w -3 && echo '' && lock-terminal-for-input.sh
