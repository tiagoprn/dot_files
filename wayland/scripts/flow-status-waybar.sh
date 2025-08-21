#!/usr/bin/env bash

STATUS=$(flow status | head -n 1)

if [ "$STATUS" = "🌊 No active session." ]; then
    class="off"
else
    class="on"
fi

echo "{\"text\": \"FLOW: $STATUS\", \"class\": \"$class\"}"
