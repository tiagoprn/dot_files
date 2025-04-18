#!/usr/bin/env bash

# === CONFIG ===

BW_CONFIG_ROOT="$HOME/.config/bw"

SELECTED_CONFIG=$(find $BW_CONFIG_ROOT/ -type f -not -name ".*" | fzf --exact)

BW_EMAIL=$(cat $SELECTED_CONFIG)
PASS_ENTRY="bitwarden/$(basename $SELECTED_CONFIG)" # ← path in `pass` where your BW password is stored
SESSION_FILE="$BW_CONFIG_ROOT/.bw_session"          # ← where to save session
CUSTOM_LOGIN_MESSAGE_FILE="$BW_CONFIG_ROOT/.custom_login_message"

echo "pass key: $PASS_ENTRY"
echo "bitwarden email: $BW_EMAIL"

# === CHECK `pass` ===
if ! command -v pass >/dev/null; then
    echo "❌ 'pass' command not found." >&2
    exit 1
fi

if [ -f "$CUSTOM_LOGIN_MESSAGE_FILE" ]; then
    cat "$CUSTOM_LOGIN_MESSAGE_FILE"
fi

# === LOGIN ===
echo "🔐 Logging in to Bitwarden..."
SESSION=$(bw login "$BW_EMAIL" --passwordfile <(pass show "$PASS_ENTRY") --raw)

if [[ -z $SESSION ]]; then
    echo "❌ Failed to get Bitwarden session." >&2
    exit 1
fi

# === SAVE SESSION ===
echo "$SESSION" >"$SESSION_FILE"
chmod 600 "$SESSION_FILE"
echo "✅ Bitwarden session saved to $SESSION_FILE"
