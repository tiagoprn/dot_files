## Bash aliases
# NOTE: do not escape with double quotes on an alias - "$()" - since that is analysed when bashrc is sourced,
#       so it will delay its execution and may lead to malfunctioning aliases. See the aliases gps
#       and gpl as examples of how to do that correctly.


## one letter aliases
alias d='docker'
alias f='fzf'
alias j="mkdir -p /storage/docs && vim +'normal Go' +'r!date' $JOURNAL_FILE +'normal!o-  '"  # opens a vim file with the current time and a line below ready for editing, useful as a journal.
alias m="make"
alias n='OUTPUT=$(navi --path "$(cat ~/.navirc)" --print) && xdotool getwindowfocus windowfocus --sync type "$OUTPUT"'
alias p="pyenv"
alias t='todo.sh -d "/storage/docs/notes/todotxt/config" '
alias v="vim"

## two letter aliases
alias dc='docker-compose'
alias dp='watch -n 1 -x bash -c "source $HOME/.bashrc && dockerps"'
alias ga="git add"
alias gc="git commit"
alias gd='git icdiff HEAD'
alias gf='git fetch'
alias gh="git log --follow -p --stat -- "  # below show all git history from a file, with diffs between changes
alias gl="git glog"
alias gr='cd `git rev-parse --show-toplevel`'  # Go to the repository root:
alias gu="git reset HEAD "  # below removes file/directory from git staging area (before committing)
alias gs="git status -s"
alias pp='pygmentize | nl --body-numbering=a '
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
alias vf='vim-fzf'
alias vi='vim --cmd "let vim_minimal=1" '
alias up='uptime'

# tree letter aliases
alias gps='git push origin `git branch | grep "*" | cut -d " " -f 2`'
alias gpl='git pull origin `git branch | grep "*" | cut -d " " -f 2`'
alias gru='cat $(git rev-parse --show-toplevel)/.git/config | grep url | cut -d "=" -f 2 | tr "\n" " "'
alias pcb='pyenv versions | grep "*" | cut -d " " -f 2 | cb'
alias vcb='xclip -i -selection clipboard -o | vim -' # Open clipboard contents on vim

## other aliases
alias list-aliases="alias"
alias list-functions="cat ~/.bash_functions | grep -i '^function' | grep -v -i '^function set' | grep -v -i '^function is' | sort"
alias watch='watch -c '
alias remove-color-codes='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'
alias decomment='egrep -v "^[[:space:]]*((#|;|//).*)?$" '
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias youtube-player='mpsyt'
alias pacman_refresh_keys='sudo pacman-key --refresh-keys'
alias pacman_update_mirrorlists='sudo reflector --verbose --age 6 --country Brazil --latest 15 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias upgrade='pacman_update_mirrorlists && sudo pacman -Syu --noconfirm && yay -Syyua --noconfirm'
alias scan-network-ips="printf 'HINT: pass the network range as the parameter, e.g. 10.0.0.1/24\n\n' && sudo nmap -sP"
# alias tmux-edit-history="vim $HOME/tmux.history"
# alias tmux-cat-history="cat $HOME/tmux.history"
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
alias cd-home="cd ~"
alias cd-storage="cd /storage"
alias cd-wal="cd ~/.cache/wal"
alias rsync-no-delete="rsync -rchzPvi --progress"
alias rsync-simple='rsync -ah --info=progress2'
alias rsync="rsync -rchzPvi --progress --delete --delete-excluded"
alias vimpager="/usr/share/vim/vim81/macros/less.sh"
alias vim-python-mode-update="cd /storage/src/dot_files/.vim/bundle/python-mode && git submodule update --init --recursive "
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
alias ubuntu-login-config="sudo vim /usr/share/gnome-shell/theme/ubuntu.css"

# Below solves the error "pyenv: cannot rehash: ~/.pyenv/shims/.pyenv-shim
# exists " when installing binaries (commands) for pip and them not working.
alias pyenv-rehash="rm -fr ~/.pyenv/shims/.pyenv-shim && $PYENV_BIN rehash"

# Aliases leveraging the cb() function
# ------------------------------------------------
alias cbssh="cbf ~/.ssh/id_rsa.pub" # Copy SSH public key
alias cbpwd="pwd | cb" # Copy current working directory
alias cbbashhistory="cat $HISTFILE | tail -n 1 | cb" # Copy most recent command in bash history

alias update-notes="notify-send -a vim 'Manually pushing notes changes to remote...' && git add . && git commit -m 'manual commit on $(hostname) at $(date -u)' > /dev/null && git push origin master > /dev/null 2>&1 && notify-send -a vim 'Notes changes pushed successfully to remote.' && gl && git status -s "
alias gbcb="git branch | grep ^* | cut -d ' ' -f 2 | cb"
alias gnome-control-center="XDG_CURRENT_DESKTOP=GNOME gnome-control-center"
alias ssh-no-host-checking='ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no"'
