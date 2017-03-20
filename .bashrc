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

## For pyenv to work
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

## Bash aliases
alias ls='ls --color -lha'

## The message below will print each time a terminal is started:
printf "BASH GIT PROMPT:\n"
printf "+ for staged, * if unstaged.\n"
printf "\$ if something is stashed.\n"
echo "% if there are untracked files."
printf "<,>,<>,= behind, ahead, diverged or equal upstream.\n"
printf "(installed 'mononoki' font for terminal/code)\n"
printf "\n"
