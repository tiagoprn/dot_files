#!/usr/bin/env bash
CURRENT_IP=$(curl realip.cc/simple)

echo "$CURRENT_IP" | wl-copy \
    && echo $(wl-paste) \
    && notify-send "Current IP: $CURRENT_IP"
