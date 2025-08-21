#!/usr/bin/env bash

# STATUS=$(flow status | head -n 1)
STATUS=$(flow status | head -n 1 | sed 's/🌊 //g' | sed 's/ Deep work: //g' | sed 's/Active for //g')

if [ "$STATUS" = "🌊 No active session." ]; then
    class="off"
else
    class="on"
fi

echo "{\"text\": \"🌊 $STATUS\", \"class\": \"$class\"}"
