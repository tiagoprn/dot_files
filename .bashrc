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

source .bash_environment
source .bash_functions
source .bash_aliases

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
  git branch > /dev/null 2>&1
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
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  PYENV_ROOT="$HOME/.pyenv"
  PYENV_BIN=$PYENV_ROOT/bin/pyenv
  if [ -f $PYENV_BIN ]; then
    if [[ `pyenv version-name` == "system" ]] ; then
        PYTHON_VIRTUALENV=""
    else
        PYTHON_VIRTUALENV="${BLUE}[PYENV:`pyenv version-name`]${COLOR_NONE} "
    fi
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi

  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}${GREEN}\u ${COLOR_NONE}at${BLUE} \h${COLOR_NONE} in ${YELLOW}\w${COLOR_NONE} ${BRANCH}
 ${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

# ---------------- BASH PROMPT (end) ----------------- #

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

# When using vim-mode, add beside the prompt and indicator if we are on visual
# or insert mode.
bind 'set show-mode-in-prompt on'

# --- KEYBOARD SHORTCUTS (BINDINGS) VIM-MODE SPECIFIC BINDINGS:

## GENERAL
# \C- = Control+
# \e = Alt+
bind -x '"\C-f":fzf-bash-history-search'
bind -x '"\C-b":tmux-save-history'
bind -x '"\C-t":tmux-search-history'
bind -x '"\ei":vim-fzf'

## VIM-MODE SPECIFIC
### Clear screen as on emacs-mode and vi-visual
bind -m vi-insert "\C-l":clear-screen

## Auto start tmux (DISABLED IN FAVOR OF MY ALIAS tmux-autostart)
# This script looks for the parent process of the bash shell.
# If bash was started from logging in or from ssh, it will execute tmux.
# If you want this to work with a GUI terminal, you can add that in there as well.
# For example, if you want to start tmux automatically when you start Ubuntu's standard gnome-terminal, you would use this:
# (reference: https://stackoverflow.com/questions/11068965/how-can-i-make-tmux-be-active-whenever-i-start-a-new-shell-session)
# PNAME="$(ps -o comm= $PPID | awk '{print $1}')";
# if [ $PNAME == "login" ] || [ $PNAME == "sshd" ] || [ $PNAME == "gnome-terminal-" ] || [ $PNAME == "termite" ] ; then
#   tmux -2 a -t work01 || exec tmux -2 new -s work01
# fi

## The message below will print each time a terminal is started:
# if [ -x "$(command -v cowsay)" ]; then
#     cowsay -f tux $(fortune -s)
# fi

printf "$(cat /storage/src/dot_files/green_lanterns.txt)"
printf '\n\n'
echo "IN BRIGHTEST DAY, IN BLACKEST NIGHT; NO EVIL SHALL ESCAPE MY SIGHT."
echo "LET THOSE WHO WORSHIP EVIL'S MIGHT, BEWARE MY POWER: GREEN LANTERN'S LIGHT!"

# if [ -x "$(command -v figlet)" ]; then
#     echo "$(hostname)" | figlet -cptk
# fi

# A better ls command, with 2 alternative aliases:
if ls --color -d . >/dev/null 2>&1; then  # GNU ls
  export COLUMNS  # Remember columns for subprocesses.
  eval "$(dircolors)"
  function ls {
    command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
  }
  alias ll='ls -l'
  alias l='ls -l -a'
fi

printf "\n- tmux-autostart <<< to start tmux sessions and attach to them."
printf "\n- list-aliases / list-functions: list all available aliases/functions."
printf "\n- If you're having pyenv shim errors after installing new binaries from pip, run: $ pyenv-rehash"
printf "\n- On ~/.ssh/config there are alias to common ssh servers (there is a copy on bitbucket/gpg/.ssh/config)."
printf "\n- You can use memory_hogs.sh and cpu_hogs.sh to get the processes that are hogging both."
printf "\n\n- Use <C-t> to copy a command from current tmux history to the clipboard, <C-f> to do
the same from bash_history. \n\n"
# fortune   -s
# fortune $(find /usr/share/games/fortunes/*.dat -printf "%f\n" | xargs shuf -n1 -e | cut -d '.' -f 1)

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# source "$(navi widget bash)"

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
