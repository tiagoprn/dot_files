#!/usr/bin/env bash
CURRENT_IP=$(curl checkip.amazonaws.com)

echo "$CURRENT_IP" | wl-copy \
    && echo $(wl-paste) \
    && notify-send "Current IP: $CURRENT_IP"
