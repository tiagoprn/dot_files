#
# ~/.bashrc
#

# file "git-prompt.sh" must be somewhere else, you can use 
# updatedb && locate git-prompt.sh to get where it is 
# (install package "mlocate" to provide "updatedb/locate").
# GITPROMPT=/usr/share/git-core/contrib/completion/git-prompt.sh
# if [ -f $GITPROMPT ];
# then
#   source $GITPROMPT
# fi

HOMEBIN=/home/$USER/local/bin
PYENVBIN=/home/$USER/.pyenv/bin
LOGGIOPSBIN=/opt/loggi/ops/ansible/bin
if [ -d $HOMEBIN ];
then
   export PATH=$PYENVBIN:$PATH:$HOMEBIN
fi
if [ -d $LOGGIOPSBIN ];
then
   export PATH=$PATH:$LOGGIOPSBIN
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Prompt configuration, customized to show git info on it:
# PS1='[\u@\h \W]\$'
PS1='\n(\t) \[\033[01;97m\]\u@\h\[\033[01;91m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;97m\] \[\033[00m\]\n\$ '
# Show git info (branch, repo status, etc on the prompt. 
# For it to work, install the package "bash-completion":
#     sudo pacman -S bash-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
source /usr/share/git/completion/git-prompt.sh
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
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

## Bash aliases
alias ls='ls --color -lha'
alias upgrade='yaourt -Syyua --noconfirm'
alias full-upgrade='sudo pacman-key --refresh-keys && sudo reflector --age 8 --fastest 128 --latest 64 --number 32 --sort rate --save /etc/pacman.d/mirrorlist && yaourt -Syyua --noconfirm'

## Unified bash history
shopt -s histappend
PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''history -a; history -c; history -r'

## Auto start tmux:
# This script looks for the parent process of the bash shell.
# If bash was started from logging in or from ssh, it will execute tmux.
# If you want this to work with a GUI terminal, you can add that in there as well.
# For example, if you want to start tmux automatically when you start Ubuntu's standard gnome-terminal, you would use this:
# (reference: https://stackoverflow.com/questions/11068965/how-can-i-make-tmux-be-active-whenever-i-start-a-new-shell-session)
PNAME="$(ps -o comm= $PPID)";
if [ $PNAME == "login" ] || [ $PNAME == "sshd" ] || [ $PNAME == "gnome-terminal-" ] ; then
  tmux -2 a -t work01 || exec tmux -2 new -s work01
fi

## The message below will print each time a terminal is started:
printf "BASH GIT PROMPT:\n"
printf "+ for staged, * if unstaged.\n"
printf "\$ if something is stashed.\n"
echo "% if there are untracked files."
printf "<,>,<>,= behind, ahead, diverged or equal upstream.\n"
printf "\n-----\n"
printf "\nUse bash aliases upgrade or full-upgrade to update your arch linux.\n" 
printf "\nTmux will autostart from existing or new session - on login, ssh or gnome-terminal.\n"
printf "\n-----\n"

