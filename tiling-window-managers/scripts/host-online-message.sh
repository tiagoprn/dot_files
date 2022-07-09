#!/bin/bash

HOSTNAME=$(hostname)
NETWORK_IFACE=$(ip -o -4 route show to default | awk '{print $5}')
NETWORK_IP=$(ip r | grep $NETWORK_IFACE | grep -oP 'src (?:\d{1,3}\.){3}\d{1,3}' | awk '{print $NF}')

MESSAGE="[ONLINE]$(date '+%Y-%m-%d %H:%M:%S'): host $HOSTNAME is online at interface $NETWORK_IFACE, IP $NETWORK_IP."
telegram-send "$MESSAGE"

