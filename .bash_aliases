## Bash aliases
# NOTE: do not escape with double quotes on an alias - "$()" - since that is analysed when bashrc is sourced,
#       so it will delay its execution and may lead to malfunctioning aliases. See the aliases gps
#       and gpl as examples of how to do that correctly.

## one letter aliases
alias f='fzf'
alias g='git'

# opens a nvim file with the current time and a line below ready for editing, useful as a journal.
alias j='mkdir -p /storage/docs && nvim +"normal Go" +"r!date" $JOURNAL_FILE +"normal!o-  "'

alias p='pyenv'
alias s='source ~/.bashrc'
alias v='SELECTED_FILE=$(find . -type f | grep -v ".git/" | grep -v "node_modules/" | fzf --preview "bat --style=numbers --color=always --line-range :50 {}") && nvim $SELECTED_FILE'

## two letter aliases
alias cc='cd $(fd --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv | fzf)'
alias gfpl='g f && g pl'
alias pa='pyenv activate $(pyenv virtualenvs | grep -v "^\s*[0-9]" | cut -d " " -f 3 | fzf)'
alias pd='pyenv deactivate '
alias pv='pyenv virtualenvs | grep -v "^\s*[0-9]"'
alias pl='pyenv install --list '
alias tm='tmux'
alias tp='tmuxp load $(find /storage/src -type f | grep -v ".git/" | grep "tmuxp/" | sort | fzf)'
alias tl='tmux ls'
alias ta='tmux -2 a -t `tmux-select-session`'
alias tk='tmux kill-session -t `tmux-select-session`'
alias vg='nvim $(git status -s | cut -d " " -f 3)'
alias vi='nvim --clean' # runs nvim with no customizations and plugins (as if fresh)
alias up='uptime'
alias zt='/storage/src/devops/bin/create-zettelkasten.sh'
alias cz='/storage/src/devops/bin/create-zettelkasten-current-folder.sh'
alias fc='/storage/src/devops/bin/create-flashcard-current-folder.sh'
alias nt='/storage/src/devops/bin/create-quick-note.sh'
alias cn='/storage/src/devops/bin/create-fleeting-note.sh'
alias nr='sudo systemctl stop NetworkManager && sudo systemctl start NetworkManager'
alias tn="/storage/src/dot_files/tiling-window-managers/scripts/tmux-nvim-project-setup.sh"

# tree letter aliases
alias cdr='cd $(g root)'
alias cht='curl -s cht.sh/$(curl -s cht.sh/:list | fzf)'
alias pcb='pyenv versions | grep "*" | cut -d " " -f 2 | cb'
alias vcb='xclip -i -selection clipboard -o | nvim -' # Open clipboard contents on nvim

## other aliases
alias today='clear &&  echo "REMINDERS" | figlet && export CURRENT_DATE=$(date "+%A %d, %B %Y") && echo -e "${CURRENT_DATE^^}\n------" && remind -s /storage/docs/reminders/personal.rem | grep "$(date +%Y/%m/%d)" | cut -f 6- -d " "'
alias watch='watch -c '
alias remove-color-codes='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'
alias decomment='egrep -v "^[[:space:]]*((#|;|//).*)?$" '
# alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias tmux-autostart='source activate core-utils && /storage/src/devops/tmuxp/start_everything.sh && source deactivate && tmux-attach'
alias pgrep='pgrep -ia'
alias ansible-edit-hosts='nvim ~/ansible/conf/hosts'
alias ansible-edit-config='nvim ~/ansible/conf/ansible.cfg'
alias ansible-ping-hosts='ansible -i ~/ansible/conf/hosts all -m ping'
alias ansible-ping-hosts-debug='ANSIBLE_DEBUG=1 ansible -vvvv -i ~/ansible/conf/hosts all -m ping'
alias ansible-play='ANSIBLE_CONFIG=~/ansible/conf/ansible.cfg ansible-playbook -i ~/ansible/conf/hosts -vv '
alias ansible-play-debug='ANSIBLE_DEBUG=1 ansible-playbook -i ~/ansible/conf/hosts -vvvv '
alias ansible-facts='ansible -i ~/ansible/conf/hosts all -m setup'
alias ssh-host-aliases='more ~/.ssh/config'
alias cd-wal='cd ~/.cache/wal'
alias rsync-no-delete='rsync -rchzPvi --progress'
alias rsync-simple='rsync -ah --info=progress2'
alias rsync='rsync -rchzPvi --progress --delete --delete-excluded'
alias chown_me='sudo chown -R $(id -u):$(id -g)'
alias moon-phase='curl -s wttr.in/moon'
# alias wttr-summary="curl -s 'wttr.in/{Sao_Paulo,Osasco,Erechim,Gramado}?format="%l:+%C+%t+%h"'"
alias wttr-summary-emojis='curl -s "wttr.in/{Sao_Paulo,Osasco,Erechim,Gramado}?format=4"'
# alias wttr-report="curl -s 'wttr.in/Sao_Paulo?lang=pt-br'"
alias qrencode='curl -F-=\<- qrenco.de'
# alias fonts-update="fc-cache -vf ~/.fonts/ && echo 'listing fonts:' && fc-list"
alias keyboard_toggle='python /storage/src/devops/bin/toggle_keyboard_layouts_on_x.py'
alias notes='tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml'

# Below solves the error "pyenv: cannot rehash: ~/.pyenv/shims/.pyenv-shim
# exists " when installing binaries (commands) for pip and them not working.
alias pyenv-rehash='rm -fr ~/.pyenv/shims/.pyenv-shim && $PYENV_BIN rehash'

# Aliases leveraging the cb() function
# ------------------------------------------------
alias cbssh='cbf ~/.ssh/id_rsa.pub'           # Copy SSH public key
alias cbpwd='pwd | cb'                        # Copy current working directory
alias cbbash='cat $HISTFILE | tail -n 1 | cb' # Copy most recent command in bash history

alias ssh-no-host-checking='ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no"'
alias compositor='/storage/src/devops/bin/toggle_compositor.sh'
alias xsession='[[ ! -z "$DISPLAY" ]] && source $HOME/.xsession'
alias ls='ls -a'
