#!/usr/bin/env bash

# Fetch data from the two services
output1=$(curl -s https://ifconfig.me/all.json)
output2=$(curl -s https://ipinfo.io)

if [[ $1 == "--only-ip" ]]; then
    # Try to extract an IPv4 address from ifconfig_me
    ipv4_from_ifconfig=$(echo "$output1" | jq -r '.ip_addr | select(. | contains(":") | not)')

    # If IPv4 is found in ifconfig_me, store in final_output, else use the IP from ipinfo_io
    if [[ -n $ipv4_from_ifconfig ]]; then
        final_output="$ipv4_from_ifconfig"
    else
        final_output=$(echo "$output2" | jq -r '.ip')
    fi
else
    # If no arguments, merge the JSONs
    final_output=$(jq -n \
        --argjson ifconfig_me "$output1" \
        --argjson ipinfo_io "$output2" \
        '{ifconfig_me: $ifconfig_me, ipinfo_io: $ipinfo_io}')
fi

echo "$final_output" | wl-paste

notify-send "Successfully copied IP data to clipboard."
