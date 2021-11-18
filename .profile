# ----- Standard .profile from pristine Ubuntu 20 install

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# ----- Customization begins below

## Default programs
export EDITOR=vim
export VISUAL=vim
export BROWSER=/usr/bin/chromium

# Set colors for less. Borrowed from
# https://wiki.archlinux.org/index.php/Color_output_in_console#less .
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline


# Set the Less input preprocessor.
if type lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN='|lesspipe.sh %s'
fi
# Syntax highlighting
if type pygmentize >/dev/null 2>&1; then
  export LESSCOLORIZER='pygmentize'
fi

# DO NOT CHANGE BELOW, BECAUSE TMUX:
export TERM=screen-256color

# SHOW x LEVELS DEEP DIRECTORIES ON CURRENT PROMPT
export PROMPT_DIRTRIM=3

HOMEBIN=/home/$USER/bin
if [ ! -d $HOMEBIN ];
then
    mkdir $HOMEBIN
fi
export PATH=$PATH:$HOMEBIN

GOPATH=$HOME/go
if [ ! -d $GOPATH ];
then
    mkdir $GOPATH
fi
export PATH=$PATH:$GOPATH

DEVOPS_BIN=/storage/src/devops/bin
if [ -d $DEVOPS_BIN ];
then
    export PATH=$PATH:$DEVOPS_BIN
fi

RUST_BIN=/opt/rust/bin
if [ -d $RUST_BIN ];
then
    export PATH=$PATH:$RUST_BIN
fi

USER_TMUX_BIN=$HOME/local/bin
if [ -d $USER_TMUX_BIN ];
then
    export PATH=$PATH:$USER_TMUX_BIN
fi

COOKIE_BIN=$HOME/.local/share/cookie/bin
if [ -d $COOKIE_BIN ];
then
    export PATH=$PATH:$COOKIE_BIN
fi

TMUX_BIN=$HOME/local/bin
if [ -d $TMUX_BIN ];
then
    export PATH=$PATH:$TMUX_BIN
fi

FZF_BIN=$HOME/.fzf/bin
if [ -d $FZF_BIN ];
then
    export PATH=$PATH:$FZF_BIN
fi

RUST_CARGO_BIN=$HOME/.cargo/bin
if [ -d $RUST_CARGO_BIN ];
then
    export PATH=$PATH:$RUST_CARGO_BIN
fi

NAVI_BIN=$HOME/bin/navi
GLOBAL_NAVI_BIN=/usr/bin/navi
if [ -f $NAVI_BIN ] || [ -f $GLOBAL_NAVI_BIN ] ;
then
    export NAVI_PATH="/storage/src/devops/cheats"
    export DAFITI_CHEATS="/storage/docs/notes/work/dafiti/cheats"
    if [ -d $DAFITI_CHEATS ];
    then
        export NAVI_PATH="$NAVI_PATH:$DAFITI_CHEATS"
    fi
fi

SCRIPTS_PATH=$HOME/apps/scripts

SCRIPTS_BIN=$SCRIPTS_PATH/bin
if [ -d $SCRIPTS_BIN ];
then
    export PATH=$PATH:$SCRIPTS_BIN
fi

SCRIPTS_ROFI=$SCRIPTS_PATH/rofi
if [ -d $SCRIPTS_ROFI ];
then
    export PATH=$PATH:$SCRIPTS_ROFI
fi

STATUSBAR_BIN=$SCRIPTS_BIN/statusbar
if [ -d $STATUSBAR_BIN ];
then
    export PATH=$PATH:$STATUSBAR_BIN
fi

# using 'kill -9 ,,' or 'cd ,,', triggers fzf for autocompletion
export FZF_COMPLETION_TRIGGER=',,'

# rg means ripgrep, that is nice to use with fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

## To stop showing warnings on activating a pyenv.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export JOURNAL_FILE=/storage/docs/journal.$HOSTNAME.md
export DOCKER_PS_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}"

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

## To run ansible locally without it being so annoying :)
export ANSIBLE_HOST_KEY_CHECKING=False

## Fixes giant screen for e.g. seafile-applet on arch linux (may happen to VLC also, so it is QT related): - Removed on 20200121 due to problems with flameshot: https://github.com/lupoDharkael/flameshot/issues/119
# export QT_AUTO_SCREEN_SCALE_FACTOR=1
# export QT_SCALE_FACTOR=0.6

export ROOT_FLATPAK_EXPORTS_DIR=/var/lib/flatpak/exports/share
if [ -d $ROOT_FLATPAK_EXPORTS_DIR ];
then
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:$ROOT_FLATPAK_EXPORTS_DIR
fi

export HOME_FLATPAK_EXPORTS_DIR=$HOME/.local/share/flatpak/exports/share
if [ -d $HOME_FLATPAK_EXPORTS_DIR ];
then
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME_FLATPAK_EXPORTS_DIR
fi

# pyenv setup, according to https://github.com/pyenv/pyenv#basic-github-checkout (ubuntu)
export PATH="$PATH:$HOME/.pyenv/bin"
eval "$(pyenv init --path)"
