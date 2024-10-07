#!/usr/bin/env bash
CURRENT_IP_DATA=$(curl realip.cc/json)

echo "$CURRENT_IP_DATA" | wl-copy \
    && echo $(wl-paste) \
    && notify-send "Current IP data: $CURRENT_IP_DATA"
