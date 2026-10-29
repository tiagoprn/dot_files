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
# Requires: pass, fzf, wl-copy, yq (mikefarah v4). notify-send optional.
# Exit codes: 0 copied or aborted by user, 1 missing tool, 2 pass/yq failed.

set -euo pipefail

readonly yaml_prefix="BTWRDN-IMPORTED"
# A content-based YAML entry must carry at least one of these keys.
readonly -a yaml_keys=(
    password username notes uri name creation_date revision_date password_history
)

notify() {
    command -v notify-send >/dev/null 2>&1 || return 0
    notify-send "code47" "$1"
}

copy() {
    printf '%s' "$1" | wl-copy
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

    for tool in pass fzf wl-copy yq; do
        command -v "$tool" >/dev/null 2>&1 || {
            echo "missing tool: $tool" >&2
            exit 1
        }
    done

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
