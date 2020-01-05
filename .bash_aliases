## Bash aliases
# NOTE: do not escape with double quotes on an alias - "$()" - since that is analysed when bashrc is sourced,
#       so it will delay its execution and may lead to malfunctioning aliases. See the aliases gps
#       and gpl as examples of how to do that correctly.
alias list-aliases="cat ~/.bashrc | grep -i '^alias' | sort"
alias list-functions="cat ~/.bashrc | grep -i '^function' | grep -v -i '^function set' | grep -v -i '^function is' | sort"
alias ls='ls --color -lha'
alias youtube-player='mpsyt'
alias pacman_refresh_keys='sudo pacman-key --refresh-keys'
alias pacman_update_mirrorlists='sudo reflector --verbose --age 6 --country Brazil --latest 15 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias upgrade='pacman_update_mirrorlists && sudo pacman -Syu --noconfirm && yay -Syyua --noconfirm'
alias jlogs='sudo journalctl -o short-iso -f --all'
alias journal="mkdir -p /storage/docs && vim +'normal Go' +'r!date' $JOURNAL_FILE"
alias tmux-autostart="source activate core-utils && /storage/src/devops/tmuxp/start_everything.sh && source deactivate && tmux -2 a -t HOME"
alias local-ports-open="netstat -netlp"
alias remote-ports-open="printf 'HINT: pass the host ip as the parameter\n\n' && sudo nmap -sS"
alias scan-network-ips="printf 'HINT: pass the network range as the parameter, e.g. 10.0.0.1/24\n\n' && sudo nmap -sP"
alias tmux-attach-session="tmux -2 a -t "
alias tmux-kill-session="tmux kill-session -t "
alias pgrep="pgrep -ia"
alias tmux-home="tmux -2 a -t HOME "
alias ansible-edit-hosts="vim ~/ansible/conf/hosts"
alias ansible-ping-hosts="ansible -i ~/ansible/conf/hosts all -m ping"
alias ansible-play="ANSIBLE_CONFIG=~/ansible/conf/ansible.cfg ansible-playbook -i ~/ansible/conf/hosts -vv "
alias ansible-play-debug="ansible-playbook -i ~/ansible/conf/hosts -vvv "
alias ansible-facts="ansible -i ~/ansible/conf/hosts all -m setup"
alias ssh-host-aliases="more ~/.ssh/config"
alias gc="git commit"
alias gss="git status -s"
alias gps='git push origin `git branch | grep "*" | cut -d " " -f 2`'
alias gpl='git pull origin `git branch | grep "*" | cut -d " " -f 2`'
alias gdf='git icdiff HEAD'
alias glg="git glog"
alias gbcb="git branch | grep ^* | cut -d ' ' -f 2 | cb"
# below show all git history from a file, with diffs between changes
alias ghistory="git log --follow -p --stat -- "
# below removes file/directory from git staging area (before committing)
alias gunstage="git reset HEAD "
alias cd-home="cd ~"
alias cd-storage="cd /storage"
alias cd-wal="cd ~/.cache/wal"
alias lsf="ls | grep -v '^d'"
alias lsd="ls | grep '^d'"
# below lists most recently changed files/directories
alias lsr="ls --color -halt"
alias rsync="rsync -rchzPvi --progress --delete --delete-excluded"
alias rsync-no-delete="rsync -rchzPvi --progress"
alias vimpager="/usr/share/vim/vim81/macros/less.sh"
alias tmux-edit-history="vim $HOME/tmux.history"
alias tmux-cat-history="cat $HOME/tmux.history"
alias vim-python-mode-update="cd /storage/src/dot_files/.vim/bundle/python-mode && git submodule update --init --recursive "
alias chown_me="sudo chown -R $(id -u):$(id -g)"
alias climate="time curl -s 'wttr.in/{Sao_Paulo,Osasco,Erechim,Gramado}?format="%l:+%C+%t+%h"'"
alias climate-report="curl -s 'wttr.in/Sao_Paulo?lang=pt-br'"
alias fonts-update="fc-cache -vf ~/.fonts/ && echo 'listing fonts:' && fc-list"
alias keyboard_toggle="python /storage/src/devops/bin/toggle_keyboard_layouts_on_x.py"
# Below solves the error "pyenv: cannot rehash: ~/.pyenv/shims/.pyenv-shim
# exists " when installing binaries (commands) for pip and them not working.
alias pyenv-rehash="rm -fr ~/.pyenv/shims/.pyenv-shim && $PYENV_BIN rehash"


# Aliases leveraging the cb() function
# ------------------------------------------------
alias cbssh="cbf ~/.ssh/id_rsa.pub" # Copy SSH public key
alias cbpwd="pwd | cb" # Copy current working directory
alias cbbashhistory="cat $HISTFILE | tail -n 1 | cb" # Copy most recent command in bash history
alias cbv='xclip -i -selection clipboard -o | vim -' # Open clipboard contents on vim


