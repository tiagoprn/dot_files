#!/usr/bin/env bash

# waybar script to display OpenRouter API credits balance in USD
# Requires OPENROUTER_API_KEY environment variable to be set

set -euo pipefail

# Source the API keys config file (works in both interactive and non-interactive contexts)
# This file should contain: export OPENROUTER_API_KEY="your-key-here"
# Or you can generate it dynamically: export OPENROUTER_API_KEY=$(pass api-keys/openrouter)
if [[ -f "$HOME/.config/wayland/api-keys.conf" ]]; then
    # shellcheck disable=SC1090
    source "$HOME/.config/wayland/api-keys.conf"
else
    # Fallback: try to source from .bashrc (only works in interactive shells)
    # shellcheck disable=SC1090
    source "$HOME/.bashrc" 2>/dev/null || true
fi

readonly API_KEY="${OPENROUTER_API_KEY:-}"
readonly API_ENDPOINT="https://openrouter.ai/api/v1/credits"

log_error() {
    printf '%s\n' "$*" >&2
}

check_prerequisites() {
    if [[ -z $API_KEY ]]; then
        log_error "Error: OPENROUTER_API_KEY environment variable is not set"
        return 1
    fi
    if ! command -v curl &>/dev/null; then
        log_error "Error: curl is required but not installed"
        return 1
    fi
}

fetch_credits() {
    local response
    response=$(curl -s \
        --max-time 30 \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "HTTP-Referer: https://github.com/openrouter/coin" \
        -H "X-Title: OpenRouter Credits Waybar" \
        "$API_ENDPOINT") || return 1

    local total_credits total_usage
    total_credits=$(printf '%s\n' "$response" | grep -oP '"total_credits"\s*:\s*\K[0-9.]+' | head -1)
    total_usage=$(printf '%s\n' "$response" | grep -oP '"total_usage"\s*:\s*\K[0-9.]+' | head -1)

    if [[ -z $total_credits || -z $total_usage ]]; then
        log_error "Error: Could not parse credits from response: $response"
        return 1
    fi

    # Calculate remaining credits: total_credits - total_usage
    local credits
    credits=$(echo "$total_credits - $total_usage" | bc)

    printf '%s' "$credits"
}

format_output() {
    local credits="$1"
    local formatted

    # Format to 2 decimal places
    formatted=$(printf '%.2f' "$credits")

    # Determine class based on balance
    local class="ok"
    if (($(echo "$credits < 2.0" | bc -l))); then
        class="critical"
    elif (($(echo "$credits < 5.0" | bc -l))); then
        class="warning"
    fi

    printf '{"text": "💳 %s", "class": "%s"}' "$formatted" "$class"
}

main() {
    check_prerequisites || return

    local credits
    credits=$(fetch_credits) || {
        log_error "Failed to fetch credits"
        return 1
    }

    format_output "$credits"
}

main
