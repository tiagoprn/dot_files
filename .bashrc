#  _   _                                    _
# | |_(_) __ _  __ _  ___  _ __  _ __ _ __ ( )___
# | __| |/ _` |/ _` |/ _ \| '_ \| '__| '_ \|// __|
# | |_| | (_| | (_| | (_) | |_) | |  | | | | \__ \
#  \__|_|\__,_|\__, |\___/| .__/|_|  |_| |_| |___/
#              |___/      |_|
#  _               _
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|

# If not running interactively, don't do anything
# This allow commands like scp or rsync to work when the destination is this machine
case $- in
    *i*) ;;
    *) return ;;
esac

# Enable vim-mode on shell editing instead of the default emacs one
# Also show on the cursor if we are on visual or insert mode
set -o vi

# Enter a directory without the cd command needed
shopt -s autocd
# minor corrections for misspellings etc.
shopt -s cdspell
# attempts to save all lines of a multiple-line command in the same history entry.
shopt -s cmdhist
## Unified bash history
shopt -s histappend

source $HOME/.bash_functions
source $HOME/.bash_aliases
if [ -f $HOME/bashrc.custom ]; then
    source $HOME/bashrc.custom
fi

# # Use GNOME Keyring as the GPG agent
# # needs "gnome-keyring" package installed and started with: '/usr/bin/gnome-keyring-daemon --start --components=gpg,ssh'
# export GPG_AGENT_INFO=
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)

# disable <Ctrl-s> permanently in terminal, which freezes it
stty -ixon

# The various escape codes that we can use to color our prompt.
RED="\[\033[0;31m\]"
YELLOW="\[\033[1;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[1;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"

# Below was added after I cleaned up my previous manual bash prompt without starship -
# otherwise, all commands would return "set_bash_prompt: command not found"
set_bash_prompt() {
    return 0
}

# --- Environment variables

export EDITOR=nvim
export VISUAL=nvim
DISTRO=$(lsb_release -sd | sed 's/"//g' | awk '{print $1}')
if [ "$DISTRO" == 'Pop!_OS' ]; then
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
fi

# using 'kill -9 ,,' or 'cd ,,', triggers fzf for autocompletion
export FZF_COMPLETION_TRIGGER=',,'

# rg means ripgrep, that is nice to use with fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

export JOURNAL_FILE=$HOME/journal.$HOSTNAME.md

## To run ansible locally without it being so annoying :)
export ANSIBLE_HOST_KEY_CHECKING=False

# Allows the same scale on monitors of different size (works e.g. for alacritty)
export WINIT_X11_SCALE_FACTOR=1.0

# Fixes cedilla caracter using 'c on GTK and QT apps
export GTK_IM_MODULE=cedilla
export QT_IM_MODULE=cedilla

# Makes all electron apps run under wayland
export ELECTRON_ENABLE_WAYLAND=1

# provides bash and git completion
# For it to work, install the package "bash-completion":
#     sudo pacman -S bash-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ ! -f /usr/share/git/completion/git-prompt.sh ]; then
    sudo mkdir -p /usr/share/git/completion/
    sudo curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o /usr/share/git/completion/git-prompt.sh
fi
source /usr/share/git/completion/git-prompt.sh

# --- KEYBOARD SHORTCUTS (BINDINGS) VIM-MODE SPECIFIC BINDINGS:
# When using vim-mode, add beside the prompt and indicator if we are on visual
# or insert mode.
## GENERAL
# \C- = Control+
# \e = Alt+
bind 'set show-mode-in-prompt on'
bind -x '"\C-r":fzf-bash-history-search'
bind -x '"\C-b":tmux-save-history'
bind -x '"\C-t":tmux-search-history'
# bind -x '"\ei":vim-fzf'
bind -x '"\C-o":vim-fzf'
### Clear screen as on emacs-mode and vi-visual
bind -m vi-insert "\C-l":clear-screen

bash /storage/src/dot_files/bash-welcome.sh

# A better ls command, with alternative aliases:
# the --indicator... removes the "*" at the end of executable files
if ls --color -d . >/dev/null 2>&1; then # GNU ls
    export COLUMNS                       # Remember columns for subprocesses.
    eval "$(dircolors)"
    function ls() {
        command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" --indicator-style=none
    }
    alias lsd='ls -la'
    alias lsa='ls -a'
    alias lss='ls -a --human-readable --size -1 -S --classify --indicator-style=none'
    alias lsr="ls -halt | less"
fi

[ -f ~/.fzf/fzf.bash ] && source ~/.fzf/fzf.bash

if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

WAYLAND_SCRIPTS_PATH="/storage/src/dot_files/wayland/scripts"
if [ -d "$WAYLAND_SCRIPTS_PATH" ]; then
    export PATH="$PATH:$WAYLAND_SCRIPTS_PATH"
fi

CARGO_BIN="$HOME/.cargo/bin"
if [ -d "$CARGO_BIN" ]; then
    export PATH="$PATH:$CARGO_BIN"
fi

GO_BIN="$HOME/go/bin"
if [ -d "$GO_BIN" ]; then
    export PATH="$PATH:$GO_BIN"
fi

# astral's "uv" and others install on this path
LOCAL_BIN="$HOME/.local/bin"
if [ -d "$LOCAL_BIN" ]; then
    export PATH="$PATH:$LOCAL_BIN"
fi

export TEXT_BROWSER=w3m
export BROWSER=firefox
export GTK_THEME=Adwaita-dark

# NOTE: below enables using 'CTRL+G' to call navi in INSERT MODE
#       and make its' commands to appear on the shell history:
#       https://github.com/denisidoro/navi/issues/462
export NAVI_PATH="$NAVI_PATH:/storage/src/devops/cheats:/home/tds/contractors/octerra/git/octerra/cheatsheets"
eval "$(navi widget bash)"

# Manage and cache your GPG keys, so you don't have to enter the passphrase repeatedly.
# For this to work, install "keychain" from your package manager (apt, pacman, etc...).
# It will only run if keychain is not already running for this user
eval "$(keychain --eval --quiet B47B5D91)"

echo "---"
# export ANTHROPIC_API_KEY=$(pass api-keys/anthropic) && echo "ANTHROPIC_API_KEY successfully set."
# export OPENAI_API_KEY=$(pass api-keys/OPENAI) && echo "OPENAI_API_KEY successfully set."
# export DEEPSEEK_API_KEY=$(pass api-keys/deepseek) && echo "DEEPSEEK_API_KEY successfully set."
export OPENROUTER_API_KEY=$(pass api-keys/openrouter) && echo "OPENROUTER_API_KEY successfully set."
echo "---"

# PYENV setup
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_BIN_PATH="$PYENV_ROOT/bin"
if [ -d "$PYENV_BIN_PATH" ]; then
    export PATH="$PATH:$PYENV_BIN_PATH"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    # This probably mean I have "uv" installed.
    # Then, I want to use the same path pyenv uses to store the venvs, so that I don't have to change my neovim and others configuration
    mkdir -p "$PYENV_ROOT/versions"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export NIX_SH_PATH="$HOME/.nix-profile/etc/profile.d/nix.sh"
if [ -f "$NIX_SH_PATH" ]; then
    source $NIX_SH_PATH
    echo "Nix successfully sourced."
fi

export RCLONE_PASSWORD_COMMAND="pass rclone/config"
export RCLONE_CONFIG_PASS="$(pass rclone/config)"
