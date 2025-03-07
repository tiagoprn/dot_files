#!/usr/bin/env bash

HOSTNAME_USER="$(hostname).$(whoami)"

if [ "$HOSTNAME_USER" == 'cosmos.tds' ]; then
    ~/contractors/octerra/git/octerra/scripts/bitwarden-credentials.sh
    exit
fi

# based on: https://git.zx2c4.com/password-store/tree/contrib/dmenu/passmenu

shopt -s nullglob globstar

typeit=0
if [[ $1 == "--type" ]]; then
    typeit=1
    shift
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=("$prefix"/**/*.gpg)
password_files=("${password_files[@]#"$prefix"/}")
password_files=("${password_files[@]%.gpg}")

password=$(printf '%s\n' "${password_files[@]}" | wofi -dmenu -p "Select a password to copy to clipboard temporarily" "$@")

[[ -n $password ]] || exit

if [[ $typeit -eq 0 ]]; then
    pass show -c "$password" 2>/dev/null
else
    pass show "$password" | {
        IFS= read -r pass
        printf %s "$pass"
    } \
        | xdotool type --clearmodifiers --file -
fi
