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

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

function v() {
  local selected_file
  selected_file=$(fd -H --exclude .git | fzf --preview "bat --style=numbers --color=always --line-range :50 {}")

  if [ -n "$selected_file" ]; then
    vim "$selected_file"
  fi
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


command_exists () {
    type "$1" &> /dev/null ;
}

function n() {
    arquivo="/usr/bin/xclip"
    if [ -f "$arquivo" ] ;
    then
        OUTPUT=$(navi --path "$(cat ~/.navirc)" --print) && echo "$OUTPUT" | xclip -selection clipboard && sleep 1 && xdotool getwindowfocus windowfocus --sync key "ctrl+shift+v"
    else
        if [ -z "$TMUX" ]
        then
            echo -e "\n --- \n WARNING: To have the best usability it is recommended to run this inside a tmux session ;) \n --- \n"
            navi --path "$(cat ~/.navirc)" --print
        else
            navi --path "$(cat ~/.navirc)" --print | while read command; do tmux send-keys "$command" ENTER; done
        fi
    fi

}

search-personal-notes() { ${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/personal" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }
search-work-notes() { ${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/work" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }
search-quick-notes() { ${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/quick" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }
search-zettels() { ${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/zettelkasten" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }
search-posts() { ${EDITOR:-vim} $(rg -n '.*' "/storage/src/tiagoprnl/content/posts" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }
search-mind-maps() { ${EDITOR:-vim} $(rg -n '.*' "/storage/src/tiagoprnl/content/mind-maps" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }

# fr() { ${EDITOR:-vim} $(rg -n '.*' "$HOME/.config/remind/" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g'); }

function cdb() {
	BOOKMARKS_FILE_PATH="/storage/src/dot_files/cd-bookmarks.$(hostname)"

	if [ -f "$BOOKMARKS_FILE_PATH" ]; then
		echo "Bookmarks file exists at $BOOKMARKS_FILE_PATH \o/"
	else
		echo "File DOES NOT exist at $BOOKMARKS_FILE_PATH. Creating..."
		echo -e "/storage/src/dot_files\n/storage/src/devops" > $BOOKMARKS_FILE_PATH
		echo "File $BOOKMARKS_FILE_PATH successfully created."
	fi

	SELECTED_DIR=$(cat $BOOKMARKS_FILE_PATH | fzf )
	echo "Entering $SELECTED_DIR..."
	cd $SELECTED_DIR
}

