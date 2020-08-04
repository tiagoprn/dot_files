function fzf-bash-history-search() {  # Function to search through bash history using fzf
    cmd=$(history | sed 's/^[ ]*[0-9]\+[ ]*//' | sort | uniq | fzf)
    # Add the command to history
    history -s $cmd
    # Copy the command to the clipboard
    echo "$cmd" | cb
    # Below I paste the command into the terminal. The setxkbmap has to be used due to a but with xdotool type on
    # non-us keyboards.
    setxkbmap us && xdotool type "$cmd" && setxkbmap -model abnt2 -layout br
}

function tmux-save-history {  # save current tmux commands to history file
    setxkbmap us && xdotool key --delay 36ms Control_L+a Alt_L+f Return && setxkbmap -model abnt2 -layout br
}

function wal-set() {  # set the desktop wallpaper through wal
    wal -n -i `find ~/Wallpapers/ | fzf --exact`
}

## since an alias can't get parameters, I create a function to simplify the call to stat to get file permissions:
# You can call it like: permissions file1 file2 file3 etc...
function permissions() {  # get files numeric permissions
    for var in "$@"  # $@ allows iterating to all arguments passed, independent of how many
    do
        stat -c '%A %a %n' $var;
    done
}

# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function cdr() {  # cd into a directory with ranger
    tempfile='`mktemp -t tmp.XXXXXX`'
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}


# color source code according to the language used and, if it can't, it will launch less on its input directly.

function cless() {  # syntax highlight the output - useful for source code, etc...
    LESSOPEN='| source-highlight --failsafe --out-format=esc256 -o STDOUT -i %s 2>/dev/null ' less -R "$@"
}


# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
function cb() {  # Copies to clipboard. You can pipe anything on the terminal to it.
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
      # Copy input to both X clipboards
      echo -n "$input" | xclip -selection clipboard
      echo -n "$input" | xclip -selection primary
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

function cbf() { cat "$1" | cb; }  # copy file contents to the clipboard

function c() {  # get a command cheatsheet online
    curl cheat.sh/$1
}

function define-word() {
    curl dict.org/d:"$1"
}

function translate-en-pt() {
    curl dict.org/d:"$1":fd-eng-por
}

function translate-pt-en() {
    curl dict.org/d:"$1":fd-por-eng
}

# fzf integrated with vim
vim-fzf() {
    local file=$(
      fzf --exact --no-multi --preview 'bat --color=always --line-range :500 {}'
      )
    if [ -n "$file" ]; then
        $EDITOR $file
    fi
}

vim-fzf-search() {
    if [ $# == 0 ]; then
        echo 'Error: search term was not provided.'
        return
    fi
    local match=$(
      rg --color=never --line-number "$1" |
        fzf --exact --no-multi --delimiter : \
            --preview "bat --color=always --line-range {2}: {1}"
      )
    local file=$(echo "$match" | cut -d':' -f1)
    if [ -n "$file" ]; then
        $EDITOR $file +$(echo "$match" | cut -d':' -f2)
    fi
}

# fzf git log browser
git-log-browser() {
    local commits=$(
      git ll --color=always "$@" |
        fzf --exact --ansi --no-sort --height 100% \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [ -n "$commits" ]; then
        local hashes=$(printf "$commits" | cut -d' ' -f2 | tr '\n' ' ')
        git show $hashes
    fi
}

function tmux-search-history() {  # search comands through saved tmux history file
    local command=$(
        cat $HOME/tmux.history | grep -e '^(ins)' | cut -c9- | sort | uniq | fzf --exact --no-multi
    )
    if [ -n "$command" ]; then
        echo "$command" | cb
        setxkbmap us && xdotool type "$command" && setxkbmap -model abnt2 -layout br
    fi
}

function tmux-search-contents() {  # search contents through saved tmux history file
    local command=$(
        cat $HOME/tmux.history | fzf --exact --no-multi
    )
    if [ -n "$command" ]; then
        echo "$command" | cb
        setxkbmap us && xdotool type "$command" && setxkbmap -model abnt2 -layout br
    fi
}

function port-open-on-public-ip() { curl -s ifconfig.co/port/$1 | python -m json.tool; }

function tmux-select-session() {
    local sessions=$(tmux ls | awk '{print $1}' | sed 's/\://g')
    echo -e "Select session: \n$sessions" | fzf
}

function dockerps () {
    docker ps --format 'table {{ .ID }}, {{ .Names }}, {{ .Status }}, {{ .Command }}, {{ .Image }}';
}


function n() {

    if [ -f /usr/bin/xclip ] ;
    then
        OUTPUT=$(navi --path "$(cat ~/.navirc)" --print) && echo "$OUTPUT" | xclip -selection clipboard && sleep 1 && xdotool getwindowfocus windowfocus --sync key "ctrl+shift+v"
    else
        navi --path "$(cat ~/.navirc)" --print
    fi

}
