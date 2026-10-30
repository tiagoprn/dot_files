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
# Requires: pass, yq, one clipboard backend (wl-copy or termux-clipboard-set),
# and one picker: tv preferred, fzf as fallback. Set PASS_PICKER=tv|fzf to
# override the order. fzf matching is forced case-insensitive; tv has no such
# flag in 0.15.9 and follows smart case: lowercase queries match
# case-insensitively, typing any capital makes matching case-sensitive.
# The tv preview masks the password and the notes of every entry, YAML or not.
# Exit codes: 0 copied or aborted by user, 1 missing tool, 2 pass/yq failed.
#
# Before any picker opens, the script warms the gpg-agent passphrase cache
# for every key listed in the store's .gpg-id files (an encrypt/decrypt
# round trip per key): cached means silence, not cached means pinentry asks
# once, at the top of the run, never inside the tv/fzf UI. This is what
# keeps the Termux UX sane.

set -euo pipefail

readonly yaml_prefix="BTWRDN-IMPORTED"
# A content-based YAML entry must carry at least one of these keys.
readonly -a yaml_keys=(
    password username notes uri name creation_date revision_date password_history
)
# Masks the tv preview for every entry: a raw first-line password (classic
# pass), `password:` lines, and the whole multiline `notes` and
# `password_history` blocks of YAML metadata entries, blank lines inside the
# blocks included. Notes can hold secrets like recovery codes, and history
# holds the old passwords in plaintext, so nothing of either may reach the pane.
# The single quotes are deliberate: the program must stay literal so the
# awk double quotes survive into tv's shell.
# shellcheck disable=SC2016
readonly mask_awk='
    skip { if ($0 == "" || $0 ~ /^[[:space:]]/) next; skip=0 }
    /^notes:/ { print "notes: [hidden]"; skip=1; next }
    /^password_history:/ { print "password_history: [hidden]"; skip=1; next }
    /^password:/ { print "password: [hidden]"; next }
    NR==1 { print "[hidden]"; next }
    { print }
'
readonly preview_cmd="pass show {} | awk '$mask_awk'"

clip_backend=""
notify_backend=""
picker=""

pick_picker_backend() {
    local choice="${PASS_PICKER:-}"

    if [[ -z $choice ]]; then
        if command -v tv >/dev/null 2>&1; then
            printf 'tv\n'
        elif command -v fzf >/dev/null 2>&1; then
            printf 'fzf\n'
        else
            return 1
        fi
    else
        command -v "$choice" >/dev/null 2>&1 || return 1
        printf '%s\n' "$choice"
    fi
}

notify() {
    [[ -n $notify_backend ]] || return 0
    case "$notify_backend" in
        notify-send) notify-send "code47" "$1" ;;
        termux-toast) printf '%s' "$1" | termux-toast ;;
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

# Warm the gpg-agent passphrase cache for every key the store encrypts with.
# An encrypt-to-self/decrypt round trip per keyid asks pinentry exactly once
# when the passphrase is not cached, and is silent when it is. A key that
# fails here logs an error and the run continues: the other key's entries
# still work. Returns 1 only when the store has no .gpg-id at all.
warm_agent_cache() {
    local store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
    local kid keyids

    keyids="$(find -L "$store" -name .gpg-id -exec cat {} \; | sort -u)" || {
        echo "could not read .gpg-id files in $store" >&2
        return 1
    }
    if [[ -z $keyids ]]; then
        echo "no .gpg-id files found in $store" >&2
        return 1
    fi

    while read -r kid; do
        [[ -n $kid ]] || continue
        echo "checking GPG passphrase cache for key $kid (pinentry asks once if not set)"
        if ! printf 'warm' | gpg --yes --trust-model always --encrypt -r "$kid" --output - 2>/dev/null \
            | gpg --decrypt --output /dev/null 2>/dev/null; then
            echo "could not decrypt with key $kid: entries using it will fail" >&2
        fi
    done <<<"$keyids"
    return 0
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
    case "$picker" in
        tv)
            tv \
                --source-command="find . -type f -name '*.gpg' | sed 's|^\./||; s|\.gpg$||'" \
                --source-output="{}" \
                --input-prompt='pass > ' \
                --preview-command="$preview_cmd" \
                --cache-preview
            ;;
        fzf)
            # Portrait phones read better with the preview below the list.
            local preview_window="right,60%,wrap"
            if [[ -n ${TERMUX_VERSION:-} ]]; then
                preview_window="down,60%,wrap"
            fi
            find . -type f -name '*.gpg' \
                | sed 's|^\./||; s|\.gpg$||' \
                | fzf --ignore-case --reverse --prompt='pass > ' \
                    --preview="pass show {} | awk '$mask_awk'" \
                    --preview-window="$preview_window"
            ;;
    esac
}

pick_field() {
    local key="$1" content="$2"

    case "$picker" in
        tv)
            printf '%s\n' "$content" | yq 'keys | .[]' \
                | tv --input-prompt="${key##*/} > "
            ;;
        fzf)
            printf '%s\n' "$content" | yq 'keys | .[]' \
                | fzf --ignore-case --reverse --prompt="${key##*/} > "
            ;;
    esac
}

field_value() {
    local content="$1" field="$2"

    printf '%s\n' "$content" | YQFIELD="$field" yq -r '.[strenv(YQFIELD)] // ""'
}

main() {
    local tool key content first_line field value

    for tool in pass yq; do
        command -v "$tool" >/dev/null 2>&1 || {
            echo "missing tool: $tool" >&2
            exit 1
        }
    done

    picker="$(pick_picker_backend)" || {
        echo "no picker available: install tv or fzf, or set PASS_PICKER to tv|fzf" >&2
        exit 1
    }

    warm_agent_cache || {
        echo "cannot warm the GPG agent: check the password store" >&2
        exit 2
    }

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
