#!/usr/bin/env bash
#
# code47.sh - fuzzy-pick a pass entry and copy what you need to the clipboard.
#
#   simple entry (first line is the password)  -> copies the first line
#   YAML metadata entry                         -> second fzf asks which field
#
# YAML detection has two tiers: any key under BTWRDN-IMPORTED/ counts, and so
# does any entry whose content parses as a YAML map carrying a known metadata
# key. A password that merely looks like "key: value" is not enough.
#
# Esc at either prompt aborts without copying. The clipboard always holds
# exactly one field, and only the field name appears in the notification.
# Pasting a multiline field keeps its internal line breaks; the final
# trailing newline is dropped.
#
# Requires: pass, fzf, yq, and one clipboard backend: wl-copy (Wayland) or
# termux-clipboard-set (Termux). Notifications use notify-send, falling back
# to termux-toast on Termux; with neither, copies work without notifications.
# Exit codes: 0 copied or aborted by user, 1 missing tool, 2 pass/yq failed.

set -euo pipefail

readonly yaml_prefix="BTWRDN-IMPORTED"
# A content-based YAML entry must carry at least one of these keys.
readonly -a yaml_keys=(
    password username notes uri name creation_date revision_date password_history
)

clip_backend=""
notify_backend=""

notify() {
    [[ -n $notify_backend ]] || return 0
    case "$notify_backend" in
    notify-send) notify-send "code47" "$1" ;;
    termux-toast) printf '%s' "$1" | termux-toast --gravity top ;;
    esac
}

pick_clipboard_backend() {
    if command -v wl-copy >/dev/null 2>&1; then
        printf 'wl-copy\n'
    elif command -v termux-clipboard-set >/dev/null 2>&1; then
        printf 'termux-clipboard-set\n'
    else
        return 1
    fi
}

pick_notify_backend() {
    if command -v notify-send >/dev/null 2>&1; then
        printf 'notify-send\n'
    elif command -v termux-toast >/dev/null 2>&1; then
        printf 'termux-toast\n'
    else
        printf 'none\n'
    fi
}

copy() {
    case "$clip_backend" in
    wl-copy) printf '%s' "$1" | wl-copy ;;
    termux-clipboard-set) printf '%s' "$1" | termux-clipboard-set ;;
    esac
}

is_yaml_entry() {
    local key="$1" content="$2"
    local expr="" k

    [[ $key == "$yaml_prefix"/* ]] && return 0
    # Content-based tier: must parse as a map AND carry a known metadata key,
    # so a simple password like "user: pass" is never mistaken for YAML.
    for k in "${yaml_keys[@]}"; do
        expr+="${expr:+ or }. == \"$k\""
    done
    printf '%s\n' "$content" | yq -e "keys | any_c($expr)" >/dev/null 2>&1
}

pick_key() {
    cd "${PASSWORD_STORE_DIR:-$HOME/.password-store}" || return 1
    find . -type f -name '*.gpg' \
        | sed 's|^\./||; s|\.gpg$||' \
        | fzf --reverse --prompt='pass > '
}

pick_field() {
    local key="$1" content="$2"

    printf '%s\n' "$content" | yq 'keys | .[]' \
        | fzf --reverse --prompt="${key##*/} > "
}

field_value() {
    local content="$1" field="$2"

    printf '%s\n' "$content" | YQFIELD="$field" yq -r '.[strenv(YQFIELD)] // ""'
}

main() {
    local tool key content first_line field value

    for tool in pass fzf yq; do
        command -v "$tool" >/dev/null 2>&1 || {
            echo "missing tool: $tool" >&2
            exit 1
        }
    done

    clip_backend="$(pick_clipboard_backend)" || {
        echo "missing clipboard tool: wl-copy or termux-clipboard-set" >&2
        exit 1
    }
    notify_backend="$(pick_notify_backend)"

    key="$(pick_key)" || exit 0
    [[ -n $key ]] || exit 0

    content="$(pass show "$key")" || {
        echo "pass show failed: $key" >&2
        exit 2
    }
    first_line="${content%%$'\n'*}"

    if is_yaml_entry "$key" "$content"; then
        field="$(pick_field "$key" "$content")" || exit 0
        [[ -n $field ]] || exit 0
        value="$(field_value "$content" "$field")" || {
            echo "yq failed: $key" >&2
            exit 2
        }
        if [[ -z $value ]]; then
            notify "$key [$field] is empty"
            exit 0
        fi
        copy "$value"
        notify "$key [$field] copied"
    else
        copy "$first_line"
        notify "$key password copied"
    fi
}

main "$@"
