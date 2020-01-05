# ---------------- BASH PROMPT (begin) ----------------- #

#   Set the bash prompt according to:
#    * the active virtualenv
#    * the branch/status of the current git repository
#    * the return value of the previous command
#    * the fact you just came from Windows and are used to having newlines in
#      your prompts.

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status='`git status 2> /dev/null`'

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${LIGHT_RED}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="# Your branch is (ahead|behind)+ "
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="AHEAD"
    else
      remote="BEHIND"
    fi
  else
    remote=""
  fi
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch='`git rev-parse --abbrev-ref HEAD`'

  # Set the final branch string.
  BRANCH="${COLOR_NONE}on branch ${LIGHT_RED}${branch}${state}${remote} ${COLOR_NONE}"
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if [ -x "$(command -v pyenv)" ]; then
      if [[ `pyenv version-name` == "system" ]] ; then
          PYTHON_VIRTUALENV=""
      else
          PYTHON_VIRTUALENV="${BLUE}[PYENV:`pyenv version-name`]${COLOR_NONE} "
      fi
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi

  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}${GREEN}\u ${COLOR_NONE}at${BLUE} \h${COLOR_NONE} in ${YELLOW}\w${COLOR_NONE} ${BRANCH}
 ${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

# ---------------- BASH PROMPT (end) ----------------- #

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


