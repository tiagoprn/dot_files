## Bash aliases
# NOTE: do not escape with double quotes on an alias - "$()" - since that is analysed when bashrc is sourced,
#       so it will delay its execution and may lead to malfunctioning aliases. See the aliases gps
#       and gpl as examples of how to do that correctly.


## one letter aliases
alias f='fzf'
alias j="mkdir -p /storage/docs && vim +'normal Go' +'r!date' $JOURNAL_FILE +'normal!o-  '"  # opens a vim file with the current time and a line below ready for editing, useful as a journal.
alias p="pyenv"
alias s="source ~/.bashrc && source ~/.profile && source ~/.bash_functions && source ~/.bash_aliases"

## two letter aliases
alias cc='cd $(fd --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv | fzf)'
alias ga="git add"
alias gc="git commit --"  # this is to avoid passing "-m" without opening vim to edit the message using the semantic commit template.
alias gd='git icdiff HEAD --color-moved'
alias gf='git fetch'
alias gl="git glog"
alias gs="git status -s"
alias pa='pyenv activate $(pyenv virtualenvs | grep -v "^\s*[0-9]" | cut -d " " -f 3 | fzf)'
alias pd='pyenv deactivate '
alias pv="pyenv virtualenvs | grep -v '^\s*[0-9]'"
alias pl='pyenv install --list '
alias tm='tmux'
alias tp="pyenv activate core-utils && tmuxp load -d "
alias tf="pyenv activate core-utils && tmuxp freeze "
alias tl="tmux ls"
alias ta='tmux -2 a -t `tmux-select-session`'
alias tk='tmux kill-session -t `tmux-select-session`'
alias vg='vim $(git status -s | cut -d " " -f 3)'
alias vi='vim --clean'  # runs vim with no customizations and plugins (as if fresh)
alias up='uptime'
alias zt='/storage/src/devops/bin/create-zettelkasten.sh'
alias nt='/storage/src/devops/bin/create-quick-note.sh'
alias nr='sudo systemctl stop NetworkManager && sudo systemctl start NetworkManager'

# tree letter aliases
alias cht='curl -s cht.sh/$(curl -s cht.sh/:list | fzf)'
alias gps='git push origin `git branch | grep "*" | cut -d " " -f 2`'
alias gpl='git pull origin `git branch | grep "*" | cut -d " " -f 2`'
alias pcb='pyenv versions | grep "*" | cut -d " " -f 2 | cb'
alias vcb='xclip -i -selection clipboard -o | vim -' # Open clipboard contents on vim

## other aliases
alias list-aliases="alias"
alias watch='watch -c '
alias remove-color-codes='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'
alias decomment='egrep -v "^[[:space:]]*((#|;|//).*)?$" '
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias tmux-autostart="source activate core-utils && /storage/src/devops/tmuxp/start_everything.sh && source deactivate && tmux-attach"
alias pgrep="pgrep -ia"
alias ansible-edit-hosts="vim ~/ansible/conf/hosts"
alias ansible-edit-config="vim ~/ansible/conf/ansible.cfg"
alias ansible-ping-hosts="ansible -i ~/ansible/conf/hosts all -m ping"
alias ansible-ping-hosts-debug="ANSIBLE_DEBUG=1 ansible -vvvv -i ~/ansible/conf/hosts all -m ping"
alias ansible-play="ANSIBLE_CONFIG=~/ansible/conf/ansible.cfg ansible-playbook -i ~/ansible/conf/hosts -vv "
alias ansible-play-debug="ANSIBLE_DEBUG=1 ansible-playbook -i ~/ansible/conf/hosts -vvvv "
alias ansible-facts="ansible -i ~/ansible/conf/hosts all -m setup"
alias ssh-host-aliases="more ~/.ssh/config"
alias cd-wal="cd ~/.cache/wal"
alias rsync-no-delete="rsync -rchzPvi --progress"
alias rsync-simple='rsync -ah --info=progress2'
alias rsync="rsync -rchzPvi --progress --delete --delete-excluded"
alias vimpager="/usr/share/vim/vim81/macros/less.sh"
alias chown_me="sudo chown -R $(id -u):$(id -g)"
alias moon-phase='curl -s wttr.in/moon'
alias wttr-summary="curl -s 'wttr.in/{Sao_Paulo,Osasco,Erechim,Gramado}?format="%l:+%C+%t+%h"'"
alias wttr-summary-emojis='curl -s "wttr.in/{Sao_Paulo,Osasco,Erechim,Gramado}?format=4"'
alias wttr-report="curl -s 'wttr.in/Sao_Paulo?lang=pt-br'"
alias public-ip="curl ifconfig.co"
alias public-ip-detailed="curl -s ifconfig.co/json | python -m json.tool"
alias qrencode="curl -F-=\<- qrenco.de"
alias fonts-update="fc-cache -vf ~/.fonts/ && echo 'listing fonts:' && fc-list"
alias keyboard_toggle="python /storage/src/devops/bin/toggle_keyboard_layouts_on_x.py"
alias notes="tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml"

# Below solves the error "pyenv: cannot rehash: ~/.pyenv/shims/.pyenv-shim
# exists " when installing binaries (commands) for pip and them not working.
alias pyenv-rehash="rm -fr ~/.pyenv/shims/.pyenv-shim && $PYENV_BIN rehash"

# Aliases leveraging the cb() function
# ------------------------------------------------
alias cbssh="cbf ~/.ssh/id_rsa.pub" # Copy SSH public key
alias cbpwd="pwd | cb" # Copy current working directory
alias cbbash="cat $HISTFILE | tail -n 1 | cb" # Copy most recent command in bash history

alias ssh-no-host-checking='ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no"'
alias compositor="/storage/src/devops/bin/toggle_compositor.sh"
alias xsession='[[ ! -z "$DISPLAY" ]] && source $HOME/.xsession'
