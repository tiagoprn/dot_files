#!/usr/bin/env bash
# Refresh the per-key OpenCode Go usage cache read by the quickshell widget.
#
# Each READ key in the keys file gets its own cache file under
# ~/.local/state/quickshell/opencode-usage/, named after the pass entry with
# every character outside [A-Za-z0-9] replaced by an underscore.
#
# gpg is told never to prompt. A timer that runs every ten minutes must not
# open a passphrase dialog on its own, so a locked agent fails this run fast;
# the cache then stays old and the widget's age line shows how old.
#
# Run by opencode-go-usage.service. See
# /storage/src/dot_files/wayland/quickshell/README.md
#
# Exit status: 0 when every key was refreshed, 1 otherwise.

set -euo pipefail

readonly KEYS_FILE="${OPENCODE_GO_KEYS_FILE:-/storage/src/aikt/pi/opencode-go-keys.txt}"
readonly CACHE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/opencode-usage"
readonly SCRIPT="${OPENCODE_GO_SCRIPT:-$HOME/scripts/opencode_go_usage.py}"
readonly UV="${OPENCODE_GO_UV:-$HOME/.local/bin/uv}"

# --pinentry-mode=error makes gpg fail instead of launching pinentry.
export PASSWORD_STORE_GPG_OPTS="--pinentry-mode=error"

log_info() {
    printf '%s INFO %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

log_error() {
    printf '%s ERROR %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

log_warn() {
    printf '%s WARN %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

# Print the cache file stem for a pass entry.
#
# Args:
#   $1: pass entry path, for example api-keys/opencode_google_read_only
#
# Returns:
#   0 and the slug on stdout, for example api_keys_opencode_google_read_only
slug() {
    printf '%s' "$1" | tr -c 'A-Za-z0-9' '_'
}

# Strip leading and trailing whitespace from a string.
#
# Args:
#   $1: input string
#
# Returns:
#   0 and the trimmed string on stdout
trim() {
    local text="$1"
    text="${text#"${text%%[![:space:]]*}"}"
    text="${text%"${text##*[![:space:]]}"}"
    printf '%s' "$text"
}

# Fetch one key's usage and write its cache file.
#
# Exit code 3 from the script means the key may not read the Go status (it is
# not a read-only key). That answer never changes, so it is logged once per run
# and not counted as a failure of this timer.
#
# Args:
#   $1: pass entry path
#
# Returns:
#   0 when the cache file was written, 2 when the key may not read the Go
#   status, 1 on a real failure
refresh_key() {
    local entry="$1"
    local cache_file
    local status=0
    cache_file="$CACHE_DIR/$(slug "$entry").json"
    "$UV" run "$SCRIPT" --widget --pass-entry "$entry" --cache-file "$cache_file" || status=$?
    if ((status == 0)); then
        log_info "refreshed $entry"
        return 0
    fi
    if ((status == 3)); then
        log_warn "skipped $entry: that key may not read the Go status"
        return 2
    fi
    log_error "failed to refresh $entry (exit $status)"
    return 1
}

main() {
    if [[ ! -r $KEYS_FILE ]]; then
        log_error "cannot read the keys file: $KEYS_FILE"
        return 1
    fi
    if [[ ! -x $UV ]]; then
        log_error "uv is not executable: $UV"
        return 1
    fi
    if [[ ! -r $SCRIPT ]]; then
        log_error "cannot read the script: $SCRIPT"
        return 1
    fi
    mkdir -p -- "$CACHE_DIR"

    local total=0
    local refreshed=0
    local skipped=0
    local failures=0
    local line entry key_status
    while IFS= read -r line; do
        [[ $line != \#* ]] || continue
        [[ $line == *READ* ]] || continue
        entry="$(trim "${line##*|}")"
        [[ -n $entry ]] || continue
        total=$((total + 1))
        key_status=0
        refresh_key "$entry" || key_status=$?
        case "$key_status" in
        0) refreshed=$((refreshed + 1)) ;;
        2) skipped=$((skipped + 1)) ;;
        *) failures=$((failures + 1)) ;;
        esac
    done <"$KEYS_FILE"

    if ((total == 0)); then
        log_error "no READ key found in $KEYS_FILE"
        return 1
    fi
    if ((failures > 0)); then
        log_error "$failures of $total keys failed, $refreshed refreshed, $skipped skipped"
        return 1
    fi
    log_info "refreshed $refreshed of $total keys into $CACHE_DIR ($skipped skipped)"
    return 0
}

main "$@"
