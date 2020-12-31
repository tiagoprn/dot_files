# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
source "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"

# PYENV_ROOT="$HOME/.pyenv"

# Determine active Python virtualenv details.
function set_virtualenv () {
  PYENV_BIN=$PYENV_ROOT/bin/pyenv
  if [ -f $PYENV_BIN ]; then
    if [[ `pyenv version-name` == "system" ]] ; then
        PYTHON_VIRTUALENV=""
    else
        PYTHON_VIRTUALENV="${BLUE}[PYENV:`pyenv version-name`]${COLOR_NONE} "
    fi
  fi
}

# ---

# - VIM MODE -
set -o vi

# When using vim-mode, add beside the prompt and indicator if we are on visual
# or insert mode.
bind 'set show-mode-in-prompt on'

## KEYBOARD SHORTCUTS (BINDINGS) VIM-MODE SPECIFIC BINDINGS:

### GENERAL
# \C- = Control+
# \e = Alt+
bind -x '"\C-f":fzf-bash-history-search'
bind -x '"\C-b":tmux-save-history'
bind -x '"\C-t":tmux-search-history'
bind -x '"\ei":vim-fzf'

### VIM-MODE SPECIFIC
#### Clear screen as on emacs-mode and vi-visual
bind -m vi-insert "\C-l":clear-screen

# - Other -

# A better ls command, with 2 alternative aliases:
if ls --color -d . >/dev/null 2>&1; then  # GNU ls
  export COLUMNS  # Remember columns for subprocesses.
  eval "$(dircolors)"
  function ls() {
    command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
  }
  alias lsd='ls -la'
  alias lsa='ls -a'
  alias lss='ls -a --human-readable --size -1 -S --classify'
  alias lsr="ls -halt"
fi

if [ -x "$(command -v figlet)" ]; then
    echo "$(hostname)" | figlet -cptk
fi

printf "$(cat $HOME/welcome.txt)"
printf '\n\n'

# ---

# For pyenv to work - DON'T MOVE THE CODE BELOW - IT MUST BE AT THE END OF THIS FILE FOR IT TO WORK
if [ -d $PYENV_ROOT ];
then
    if ! [ -x "$(command -v pyenv)" ]; then
        echo 'pyenv is not installed, I recommend you to install it.' # >&2
    else
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi
fi


