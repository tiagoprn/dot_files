function fzf-bash-history-search() {  # search through bash history using fzf
    cmd=$(history | sed 's/^[ ]*[0-9]\+[ ]*//' | sort | uniq | fzf)
    # Add the command to history
    history -s $cmd
    # Copy the command to the clipboard
    echo "$cmd" | cb
    # Below I paste the command into the terminal. The setxkbmap has to be used due to a but with xdotool type on
    # non-us keyboards.
    setxkbmap us && xdotool type "$cmd" && setxkbmap -model abnt2 -layout br
}

function _fzf_comprun() {  # select a file under current directory
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

function tmux-save-history() {  # save current tmux commands to history file
    setxkbmap us && xdotool key --delay 36ms Control_L+a Alt_L+f Return && setxkbmap -model abnt2 -layout br
}

function wal-set() {  # set the desktop wallpaper through wal
    wal -n -i `find ~/Wallpapers/ | fzf --exact`
}

function permissions() {  # get files numeric permissions
    for var in "$@"  # $@ allows iterating to all arguments passed, independent of how many
    do
        stat -c '%A %a %n' $var;
    done
}

function cb() {  # Copies to clipboard. You can pipe anything on the terminal to it
  local _scs_col="\e[0;32m" _wrn_col='\e[1;31m' _trn_col='\e[0;33m'

  # Check that wl-copy is installed.
  if ! command -v wl-copy > /dev/null; then
    echo -e "${_wrn_col}You must have the 'wl-copy' program installed.\e[0m"
    return 1
  fi

  # Check user is not root (root doesn't have access to user xorg server)
  if [[ "$USER" == "root" ]]; then
    echo -e "${_wrn_col}Must be regular user (not root) to copy a file to the clipboard.\e[0m"
    return 1
  fi

  # If no tty, data should be available on stdin
  if ! [[ "$(tty)" == /dev/* ]]; then
    input="$(< /dev/stdin)"
  else
    input="$*"
  fi

  if [ -z "$input" ]; then  # If no input, print usage message.
    echo "Copies a string to the clipboard."
    echo "Usage: cb <string>"
    echo "       echo <string> | cb"
    return 1
  fi

  # Copy input to the clipboard
  echo -n "$input" | wl-copy

  # Truncate text for status
  if [ ${#input} -gt 80 ]; then
    input="$(echo "$input" | cut -c1-80)${_trn_col}...\e[0m"
  fi

  # Print status.
  echo -e "${_scs_col}Copied to clipboard:\e[0m $input"
}

function cbf() {  # copy file contents to the clipboard
	cat "$1" | cb;
}

function c() {  # get a command cheatsheet online
    curl cheat.sh/$1
}

function define-word() {  # search for a word on dict.org
    curl dict.org/d:"$1"
}

function translate-en-pt() {  # translate work from english to portuguese
    curl dict.org/d:"$1":fd-eng-por
}

function translate-pt-en() {  # translate work from portuguese to english
    curl dict.org/d:"$1":fd-por-eng
}

function vim-fzf() {  # select one or more files with fzf and open with EDITOR (use TAB for multiselect)
    local file=$(
      fzf --exact -m --preview 'bat --color=always --line-range :500 {}'
      )
    if [ -n "$file" ]; then
        $EDITOR $file
    fi
}

function vim-fzf-search() {  # search for a term using rg and fzf and open the selected file with EDITOR on the match
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


function git-log-browser() {  # select git commit hash and get more details about it
    local commits=$(
      git ll --color=always "$@" |
        fzf --exact --ansi --no-sort --height 100% \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [ -n "$commits" ]; then
        local hashes=$(printf "$commits" | cut -d' ' -f4 | tr '\n' ' ')
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

function tmux-select-session() {  # select a tmux session
    local sessions=$(tmux ls | awk '{print $1}' | sed 's/\://g')
    echo -e "Select session: \n$sessions" | fzf
}

function dockerps () {  # docker ps with custom formatting
    docker ps --format 'table {{ .ID }}, {{ .Names }}, {{ .Status }}, {{ .Command }}, {{ .Image }}';
}

function command_exists () {  # check if a command exists
    type "$1" &> /dev/null ;
}

# function n() {  # run a command from navi cheatsheet
#     arquivo="/usr/bin/xclip"
#     if [ -f "$arquivo" ] ;
#     then
#         OUTPUT=$(navi --fzf-overrides '--color=bw,fg+:#bf2a2a,bg+:#ffffff,preview-fg:#bf2a2a' --path "$(cat ~/.navirc)" --print) && echo "$OUTPUT" | xclip -selection clipboard && sleep 1 && xdotool getwindowfocus windowfocus --sync key "ctrl+shift+v"
#     else
#         if [ -z "$TMUX" ]
#         then
#             echo -e "\n --- \n WARNING: To have the best usability it is recommended to run this inside a tmux session ;) \n --- \n"
#             navi --path "$(cat ~/.navirc)" --print
#         else
#             navi --path "$(cat ~/.navirc)" --print | while read command; do tmux send-keys "$command" ENTER; done
#         fi
#     fi
#
# }

function search-personal-notes() {  # search on personal notes
	${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/personal" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g');
}
function search-work-notes() {  # search on work notes
	${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/work" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g');
}
function search-quick-notes() {  # search on quick notes
	${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/quick" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g');
}
function search-zettels() {  # search on default zettels
	${EDITOR:-vim} $(rg -n '.*' "/storage/docs/notes/zettelkasten" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g');
}
function search-posts() {  # search on tiagoprnl posts
	${EDITOR:-vim} $(rg -n '.*' "/storage/src/tiagoprnl/content/posts" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g');
}
function search-mind-maps() {  # search on tiagoprnl mind-maps
	${EDITOR:-vim} $(rg -n '.*' "/storage/src/tiagoprnl/content/mind-maps" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g');
}

function search-reminders() {  # search on reminders
	${EDITOR:-vim} $(rg -n '.*' "/storage/src/reminders" | fzf --layout=reverse --height 50% --ansi | sed -E 's/(.*):([0-9]+):.*/\1 +\2/g');
}

function cdb() {  # cd into a path defined on the bookmarks file
	BOOKMARKS_FILE_PATH="$HOME/.config/cd-bookmarks.list"

	if [ -f "$BOOKMARKS_FILE_PATH" ]; then
		echo "Bookmarks file exists at $BOOKMARKS_FILE_PATH \o/"
	else
		echo "File DOES NOT exist at $BOOKMARKS_FILE_PATH. Creating..."
		echo -e "/storage/src/dot_files\n/storage/src/devops" > $BOOKMARKS_FILE_PATH
		echo "File $BOOKMARKS_FILE_PATH successfully created."
	fi

	SELECTED_DIR=$(cat $BOOKMARKS_FILE_PATH | fzf | cut -d '|' -f 1 )
	echo "Entering $SELECTED_DIR..."
	cd "$SELECTED_DIR"
}

function cdg() {  # cd into a path defined on the git bookmarks file
	BOOKMARKS_FILE_PATH="$HOME/.config/git-projects-bookmarks.list"

	if [ -f "$BOOKMARKS_FILE_PATH" ]; then
		echo "Bookmarks file exists at $BOOKMARKS_FILE_PATH \o/"
	else
		echo "File DOES NOT exist at $BOOKMARKS_FILE_PATH. Creating..."
		echo -e "/storage/src/dot_files\n/storage/src/devops" > $BOOKMARKS_FILE_PATH
		echo "File $BOOKMARKS_FILE_PATH successfully created."
	fi

	SELECTED_DIR=$(cat $BOOKMARKS_FILE_PATH | fzf | cut -d '|' -f 1 )
	echo "Entering $SELECTED_DIR..."
	cd "$SELECTED_DIR"
}

function cdf() {  # select on fzf a directory you want to enter into
    local dir
    dir=$(find . -type d -name '.git' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}
