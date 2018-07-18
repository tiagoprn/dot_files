#
# ~/.bashrc
#

HOMEBIN=/home/$USER/local/bin
if [ -d $HOMEBIN ];
then
   export PATH=$PATH:$HOMEBIN
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
  git_status="$(git status 2> /dev/null)"

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
  branch="$(git rev-parse --abbrev-ref HEAD)"

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
  if [[ `pyenv version-name` == "system" ]] ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[PYENV:`pyenv version-name`]${COLOR_NONE} "
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

## Default programs
export EDITOR=vim
export BROWSER=/usr/bin/chromium

## For tmux to work nicely
export TERM=xterm-256color 

## To stop showing warnings on activating a pyenv.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

## Bash aliases
alias ls='ls --color -lha'
alias upgrade='pyenv deactivate && yaourt -Syyua --noconfirm'
alias full-upgrade='pyenv deactivate && sudo pacman-key --refresh-keys && sudo reflector --age 8 --fastest 128 --latest 64 --number 32 --sort rate --save /etc/pacman.d/mirrorlist && yaourt -Syyua --noconfirm'
alias jlogs='sudo journalctl -o short-iso -f --all'

## since an alias can't get parameters, I create a function to simplify the call to stat to get file permissions: 
# You can call it like: permissions file1 file2 file3 etc...
permissions() {
    for var in "$@"  # $@ allows iterating to all arguments passed, independent of how many
    do    
        stat -c '%A %a %n' $var;
    done    
}

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}
# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbwd="pwd | cb"
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"

## Unified bash history
shopt -s histappend
PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''history -a; history -c; history -r'

## Fixes giant screen for e.g. seafile-applet on arch linux (may happen to VLC also, so it is QT related):
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=0.6

## Auto start tmux:
# This script looks for the parent process of the bash shell.
# If bash was started from logging in or from ssh, it will execute tmux.
# If you want this to work with a GUI terminal, you can add that in there as well.
# For example, if you want to start tmux automatically when you start Ubuntu's standard gnome-terminal, you would use this:
# (reference: https://stackoverflow.com/questions/11068965/how-can-i-make-tmux-be-active-whenever-i-start-a-new-shell-session)
PNAME="$(ps -o comm= $PPID | awk '{print $1}')";
if [ $PNAME == "login" ] || [ $PNAME == "sshd" ] || [ $PNAME == "gnome-terminal-" ] ; then
  tmux -2 a -t work01 || exec tmux -2 new -s work01
fi

## The message below will print each time a terminal is started:
if [ -x "$(command -v cowsay)" ]; then
    cowsay -f tux $(fortune -s)
fi
printf "\n--- WELCOME TO $HOSTNAME ---"
printf "\nUse bash aliases upgrade or full-upgrade to update your arch linux." 
printf "\nTmux will autostart from existing or new session - on login, ssh or gnome-terminal."
printf "\nAlias to journald logs: jlogs"
printf "\nAliases/functions to xclip (pacman package has the same name) to copy from the terminal to the X Clipboard (can also be used on pipes): cb[tab] "
printf "\nIf you're having pyenv shim errors after installing new binaries from pip, run: $ pyenv-rehash"
printf "\n--- Have fun! ---\n"

## For pyenv to work - DON'T MOVE THE CODE BELOW - IT MUST BE AT THE END OF THIS FILE FOR IT TO WORK
if ! [ -x "$(command -v pyenv)" ]; then
    echo 'pyenv is not installed, I recommend you to install it.' >&2
    exit 1
fi


export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"  # not useful, since I install it from the package manager

if [ -d $PYENV_ROOT ];
then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


# Below solves the error "pyenv: cannot rehash: ~/.pyenv/shims/.pyenv-shim
# exists " when installing binaries (commands) for pip and them not working.
alias pyenv-rehash="rm -fr ~/.pyenv/shims/.pyenv-shim && pyenv rehash"

UTILS_VIRTUALENV=$(pyenv virtualenvs | grep 'utils' | grep -v 'envs' | awk '{print $2}')
if [ -n "$UTILS_VIRTUALENV" ]; then
    pyenv activate utils
else
    echo 'The "utils" pyenv virtualenv is not installed. Install it for this message to vanish.'
fi
