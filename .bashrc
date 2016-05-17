#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$'
BROWSER=/usr/bin/chromium

# Show git info (branch, repo status, etc on the prompt. 
# For it to work, install the package "bash-completion":
#     sudo pacman -S bash-completion

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
source /usr/share/git/completion/git-prompt.sh
export PS1='\n(\t) \[\033[01;97m\]\u@\h\[\033[01;91m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;97m\] \[\033[00m\]\n\$ '
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM=auto

export EDITOR=vim

printf "BASH GIT PROMPT:\n"
printf "+ for staged, * if unstaged.\n"
printf "\$ if something is stashed.\n"
echo "% if there are untracked files."
printf "<,>,<>,= behind, ahead, diverged or equal upstream.\n"
printf "\n"

alias ls='ls --color -lha'
