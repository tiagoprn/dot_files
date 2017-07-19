#
# ~/.bashrc
#

HOMEBIN=/home/$USER/local/bin
PYENVBIN=/home/$USER/.pyenv/bin
if [ -d $HOMEBIN ];
then
   export PATH=$PYENVBIN:$PATH:$HOMEBIN
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

## Prompt configuration, customized to show git info on it:
# PS1='[\u@\h \W]\$'
PS1='\n(\t) \[\033[01;97m\]\u@\h\[\033[01;91m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;97m\] \[\033[00m\]\n\$ '

export PS1
# export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=1
# export GIT_PS1_SHOWSTASHSTATE=1
# export GIT_PS1_SHOWUPSTREAM=auto

## Default programs
export EDITOR=vim
export BROWSER=/usr/bin/chromium

## For tmux to work nicely
export TERM=xterm-256color 

## For pyenv to work
if [ -d $PYENVBIN ];
then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

## Bash aliases
alias ls='ls --color -lha'
alias upgrade='yaourt -Syyua --noconfirm'
alias full-upgrade='sudo pacman-key --refresh-keys && sudo reflector --age 8 --fastest 128 --latest 64 --number 32 --sort rate --save /etc/pacman.d/mirrorlist && yaourt -Syyua --noconfirm'
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
printf "\n-----\n"
printf "\nUse bash aliases upgrade or full-upgrade to update your arch linux.\n" 
printf "\nTmux will autostart from existing or new session - on login, ssh or gnome-terminal.\n"
printf "\nAlias to journald logs: jlogs"
printf "\nAliases/functions to xclip (pacman package has the same name) to copy from the terminal to the X Clipboard (can also be used on pipes): cb[tab] "
printf "\n-----\n"

