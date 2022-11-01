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

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# disable <Ctrl-s> permanently in terminal, which freezes it
stty -ixon

# ---------------- BASH PROMPT (begin) ----------------- #

#   Set the bash prompt according to:
#    * the active virtualenv
#    * the branch/status of the current git repository
#    * the return value of the previous command
#    * the fact you just came from Windows and are used to having newlines in
#      your prompts.

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

# Detect whether the current directory is a git repository.
function is_git_repository {
    git branch >/dev/null 2>&1
}

# Determine the branch/state information for this git repository.
function set_git_branch {
    # Capture the output of the "git status" command.
    git_status='`git status 2> /dev/null`'

    # Set color based on clean/staged/dirty.
    if [[ ${git_status} =~ "working directory clean" ]]; then
        state="${GREEN}"
    elif [[ ${git_status} =~ "Changes to be committed" ]]; then
        state="${YELLOW}"
    else
        state="${LIGHT_RED}"
    fi

    # Set arrow icon based on status against remote.
    remote_pattern="# Your branch is (ahead|behind)+ "
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote="AHEAD"
        else
            remote="BEHIND"
        fi
    else
        remote=""
    fi
    diverge_pattern="# Your branch and (.*) have diverged"
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="↕"
    fi

    # Get the name of the branch.
    branch='`git rev-parse --abbrev-ref HEAD`'

    # Set the final branch string.
    BRANCH="${COLOR_NONE}on branch ${LIGHT_RED}${branch}${state}${remote} ${COLOR_NONE}"
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol() {
    if test $1 -eq 0; then
        PROMPT_SYMBOL='$'
    else
        PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
    fi
}

# Determine active Python virtualenv details.
function set_virtualenv() {
    PYENV_ROOT="$HOME/.pyenv"
    PYENV_BIN=$PYENV_ROOT/bin/pyenv
    if [ -f $PYENV_BIN ]; then
        if [[ $(pyenv version-name) == "system" ]]; then
            PYTHON_VIRTUALENV=""
        else
            PYTHON_VIRTUALENV="${BLUE}[PYENV:$(pyenv version-name)]${COLOR_NONE} "
        fi
    fi
}

# Set the full bash prompt.
function set_bash_prompt() {
    # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
    # return value of the last command.
    set_prompt_symbol $?

    # Set the PYTHON_VIRTUALENV variable.
    set_virtualenv

    # Set the BRANCH variable.
    if is_git_repository; then
        set_git_branch
    else
        BRANCH=''
    fi

    # Set the bash prompt variable.
    PS1="
[\d \t] ${PYTHON_VIRTUALENV}${GREEN}\u ${COLOR_NONE}at${BLUE} \h${COLOR_NONE} in ${YELLOW}\w${COLOR_NONE} ${BRANCH}
${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

# ---------------- BASH PROMPT (end) ----------------- #

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

# A better ls command, with 2 alternative aliases:
if ls --color -d . >/dev/null 2>&1; then # GNU ls
    export COLUMNS                       # Remember columns for subprocesses.
    eval "$(dircolors)"
    function ls() {
        command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
    }
    alias lsd='ls -la'
    alias lsa='ls -a'
    alias lss='ls -a --human-readable --size -1 -S --classify'
    alias lsr="ls -halt"
fi

[ -f ~/.fzf/fzf.bash ] && source ~/.fzf/fzf.bash

if ! [ -x "$(command -v startx)" ]; then
    echo -e " -------------------------------------------------------\n"
    echo -e " No xorg detected, since 'startx' has not been found.\n"
    echo -e " You can use navi to start tmux if it is installed... ;)\n"
    echo -e " -------------------------------------------------------\n"
fi

if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

TILING_WM_SCRIPTS_PATH="/storage/src/dot_files/tiling-window-managers/scripts"
if [ -d "$TILING_WM_SCRIPTS_PATH" ]; then
    export PATH="$PATH:$TILING_WM_SCRIPTS_PATH"
fi

CARGO_BIN="$HOME/.cargo/bin"
if [ -d "$CARGO_BIN" ]; then
    export PATH="$PATH:$CARGO_BIN"
fi

LOCAL_BIN="$HOME/.local/bin"
if [ -d "$LOCAL_BIN" ]; then
    export PATH="$PATH:$LOCAL_BIN"
fi

export TEXT_BROWSER=w3m
export BROWSER=firefox

# PYENV setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"
## To stop showing warnings on activating a pyenv:
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
