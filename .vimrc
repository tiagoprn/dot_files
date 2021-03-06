" vim:fdm=marker
" vim:fmr=<<<,>>>

" _   _                                    _             _
"| |_(_) __ _  __ _  ___  _ __  _ __ _ __ ( )___  __   _(_)_ __ ___  _ __ ___
"| __| |/ _` |/ _` |/ _ \| '_ \| '__| '_ \|// __| \ \ / / | '_ ` _ \| '__/ __|
"| |_| | (_| | (_| | (_) | |_) | |  | | | | \__ \  \ V /| | | | | | | | | (__
" \__|_|\__,_|\__, |\___/| .__/|_|  |_| |_| |___/   \_/ |_|_| |_| |_|_|  \___|
"             |___/      |_|
"

" Vundle <<<
" I use VUNDLE "package manager" and its plugins.

" DO NOT ADD ANYTHING TO THIS SECTION, IT IS INTENDED ONLY FOR VUNDLE AND ITS PLUGIN
" DECLARATION/SETUP. YOU CAN ADD YOUR CONFIGURATION AFTER THE SECTION "MAIN SETTINGS"
" ON THIS FILE.

" we need to make sure that vim is not attempting to retain compatibility with
" vi, its predecessor. This is a vundle requirement.
set nocompatible

" When in insert mode, ready to paste, vim will switch to paste mode, which will not try to ident
" code when you paste it from another app, like the browser or a text editor.
" IMPORTANT: DO NOT MOVE this line from here, it must be after nocompatible for the paste toggle to
" work accordingly.
set pastetoggle=<F4>| " function key: toggle insert paste mode

" We also want to turn off the default "filetype" controls for now because the
" way that vim caches filetype rules at runtime interferes with the way that
" vundle alters the runtime environment.
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" We could also add repositories with a ".git" extension

" To get plugins from Vim Scripts, you can reference the plugin
" by name as it appears on the site

" git plugin
" Plugin 'tpope/vim-fugitive' --- removed, because it is not taking into account the current directory e.g. on `git blame`.

"fzf plugins
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" snippets support plugins
" ultisnips removed due to conflict with vim-pyenv
"" snipmate is an alternative snippet manager to ultisnips (not python)
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
"" Plugin that provides some default snippets for various languages
Plugin 'honza/vim-snippets'

" Add specific actions for directories creating a .vimdir file on a specific directory
Plugin 'chazy/dirsettings'

" Alternative to tagbar. Needs universal-ctags compiled for your distro
Plugin 'liuchengxu/vista.vim'

" Vim color scheme to be used with pywal
Plugin 'dylanaraps/wal.vim'

" language-server support
Plugin 'davidhalter/jedi-vim'
Plugin 'lambdalisue/vim-pyenv'
Plugin 'zchee/deoplete-jedi'
Plugin 'ervandew/supertab'
Plugin 'w0rp/ale'

" comment/uncomment blocks of code/text
Plugin 'tpope/vim-commentary'

" goyo - for distraction-free writing
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'

" markdown linter
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-surround'

" makes possible to customize fzf-vim rg command
Plugin 'jesseleite/vim-agriculture'

" show contents of vim registers on a sidebar
Plugin 'junegunn/vim-peekaboo'

" Sends text to another tmux window (use with ipython or other REPL, e.g. pgcli etc):
Plugin 'jpalardy/vim-slime'

" python text objects
Plugin 'jeetsukumaran/vim-pythonsense'

" Better snippets browsing (works on normal and insert mode):
Plugin 'Yggdroot/LeaderF'
Plugin 'skywind3000/Leaderf-snippet'

" macros persitance
Plugin 'chamindra/marvim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" >>>

" Main Settings <<<
" Rebind <Leader> key
map <SPACE> <leader>

syntax on

" Color scheme (must be in ~/.vim/colors)
" set background=dark
colorscheme wal

" enabling color support - part 2 (https://wiki.archlinux.org/index.php/st#Patches)
set t_Co=256                         " Enable 256 colors

" font (commented to use the same font as set on the terminal)
" set anti gfn=JetBrains\ Mono\ 11
" set guifont=Fira\ Code\ 11
" set guifont=JetBrains\ Mono\ 11

set title
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*~

set relativenumber  " Changing the ruler position
set number  " show line numbers
" set winwidth=80  "minimum window width

" set formatoptions-=r  " Automatically insert the current comment leader after hitting <Enter> in Insert mode.
" set formatoptions-=c  " Auto-wrap comments using textwidth, inserting the current comment leader automatically.
" set formatoptions-=o  " Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set formatoptions+=j  " Remove comment leader when joining comment lines

augroup pythonconf
    autocmd!
    autocmd FileType py set textwidth=79
    autocmd FileType py set formatoptions+=t  " automatically wrap text when typing
    autocmd FileType py set formatoptions-=l  " Force line wrapping

    " TABs to spaces
    autocmd FileType py set tabstop=4
    autocmd FileType py set softtabstop=4
    autocmd FileType py set shiftwidth=4
    autocmd FileType py set shiftround
    autocmd FileType py set expandtab

    " Indentation
    autocmd FileType py set autoindent
    autocmd FileType py set smartindent
augroup END

augroup luaconf
    autocmd!
    autocmd FileType lua set textwidth=79
    autocmd FileType lua set formatoptions+=t  " automatically wrap text when typing
    autocmd FileType lua set formatoptions-=l  " Force line wrapping

    " TABs to spaces
    autocmd FileType lua set tabstop=2
    autocmd FileType lua set softtabstop=2
    autocmd FileType lua set shiftwidth=2
    autocmd FileType lua set shiftround
    autocmd FileType lua set expandtab

    " Indentation
    autocmd FileType lua set autoindent
    autocmd FileType lua set smartindent
augroup END

augroup textconf
    autocmd!
    " set virtualedit=all  " BREAKTHROUGH CHANGE: allows to move the cursor past the last character. If you insert a new character there, it is automatically padded with spaces. Useful for e.g. tables
    " autocmd FileType markdown,text InsertLeave * normal gwap<CR> " formats the current paragraph when leaving insert mode
    " do not use textwidth with soft wrap, it has no effect
    autocmd FileType markdown,text,vim set linebreak  " soft wrap: wrap the text when it hits the screen edge
augroup END

" Below is because of:
" https://stackoverflow.com/questions/42377945/vim-adding-cursorshape-support-over-tmux-ssh
set t_SI=[6\ q
set t_SR=[4\ q
set t_EI=[2\ q

" the File, Open dialog defaults to the current file's directory.
set browsedir=buffer

" automatically change window's cwd to file's dir - can break some plugins, better not to be enabled
" set autochdir

" Auto-reload files
set autoread

" When the cursor moves outside the viewport of the current window, the buffer scrolls a single
" line to keep the cursor in view. Setting the option below will start the scrolling x lines
" before the border, keeping more context around where you’re working.
set scrolloff=3

" Change the sound beep on errors to screen flashing
set visualbell

" Height of the command bar
set cmdheight=1

" Disable backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" Better Searching
set hlsearch             " highlight searches
set incsearch            " show search matches while you type
set ignorecase           " ignore case on searching by default
set smartcase            " uppercase characters will be taken into account

set listchars=tab:→␣,space:·,nbsp:␣,trail:•,eol:↩,precedes:«,extends:»

" :help viminfo
set viminfo='1000,f1,<500

" STATUS LINE
"" Functions used on status line
function! ReadonlyStatus()
    if &filetype == "help"
        return ""
    elseif &readonly
        return ""
    else
        return ""
    endif
endfunction

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'   '.l:branchname.' ':''
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

"" Always show the status line
set laststatus=2

"" Format the status line
set statusline=
set statusline+=%{ReadonlyStatus()}
set statusline+=%F%m%r%h
set statusline+=\ %y
set statusline+=\ COL:%c
set statusline+=\ WORDS:%{wordcount().words}
set statusline+=\ LINTER:%{LinterStatus()}
" set statusline+=\ \ \ CWD:%{getcwd()}
set statusline+=%=      "left/right separator
set statusline+=\ \ \ %{StatuslineGit()}
set statusline+=\ LINE\:%l/%L(%P)

" >>>

" Custom key [re]mappings <<<
" FIXME: glitches do not occur on pure txt files
nnoremap <C-u> :undo<CR>| " undo changes
nnoremap <Leader><Space> :w! \| :redraw!<CR>| " (core) save file and redraw screen to cleanup from glitches
nnoremap <Leader><Space>r :redraw!<CR>| " (core) redraw screen to cleanup from glitches
nnoremap <Leader><Space>w :windo w! \| :q!<CR>| " (core) save all files and quit
nnoremap <Leader><Space>q :q!<CR>| " (core) quit
nnoremap <C-e> :e<CR>| " (core) reload file

nnoremap <CR> :nohlsearch<cr>| " de-highlights current highlighted search

map <Leader>all <esc>gg0vG$<CR>| " select all text in the file

" WINDOWS
" move between window splits
nnoremap <Leader>wj <c-w>j| " (windows) move to down window
nnoremap <Leader>wk <c-w>k| " (windows) move to up window
nnoremap <Leader>wh <c-w>h| " (windows) move to left window
nnoremap <Leader>wl <c-w>l| " (windows) move to right window
" shift window splits
nnoremap <Leader>wJ <c-w>J| " (windows) shift to down window
nnoremap <Leader>wK <c-w>K| " (windows) shift to up window
nnoremap <Leader>wH <c-w>H| " (windows) shift to left window
nnoremap <Leader>wL <c-w>L| " (windows) shift to right window
nnoremap <Leader>wr <c-w>r| " (windows) shift rotate split window
" change split orientation
noremap <Leader>ws  <c-w>t<c-w>K| " (windows) change split orientation to horizontal
noremap <Leader>wv  <c-w>t<c-w>H| " (windows) change split orientation to vertical
" misc
nnoremap <Leader>ww <C-w>w| " (windows)  toggle between windows
nnoremap <Leader>wV :vnew<CR>| " (windows) new vertical window split
nnoremap <Leader>wS :new<CR>| " (windows) new horizontal window split

" When on visual selection mode (v), then
" easier moving of code blocks
" Try to go into visual selection mode (v), then
" select several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation| " (VISUAL) deindent selection
vnoremap > >gv  " better indentation| " (VISUAL) indent selection

nnoremap <silent> <F6> :set list!<CR>| " function key: toggle showing special chars (listchars)

" OVERRIDING COLORS
" Overriding color of special chars
" highlight SpecialKey ctermfg=red guifg=red
" Overriding color of the line numbers
highlight LineNr ctermbg=black ctermfg=darkblue
" Overriding color of the status line
highlight StatusLine ctermbg=black ctermfg=darkblue
" Overriding color of the popup menu
highlight Pmenu ctermbg=darkgrey ctermfg=black

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>| " search forwards current highlighted selection
vnoremap <silent> # :call VisualSelection('b')<CR>| " search backwards current highlighted selection

" Auto setup vim make command to run lint
let project_path = system("git rev-parse --show-toplevel | tr -d '\\n'")
let &makeprg = "cd " . project_path . " && make lint"
nnoremap <expr> <F9> '<Esc>:cd ' . project_path . ' \| make<CR>'| " function key: Run linter

nnoremap <Backspace> :bw<Enter>| " Close buffer
nnoremap <leader>q :bp\|bw \#<Enter>| " Close buffer but keep split
nnoremap <leader><Backspace> <C-w>q<Enter>| " Close split but keep buffer

" session management (below, <BS> means the backspace key,
"                     and <C-D> list existing files through cli completion)
let g:sessions_dir = '~/vim-sessions'
exec 'nnoremap <Leader>ss :mks! ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'| " save current session
exec 'nnoremap <Leader>so :so ' . g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'| " open session

" Copy current buffer name to clipboard
nnoremap <Leader>fcb :let @+=expand('%:p')<CR>| " copy current file name to clipboard

" DISABLE ARROW KEYS IN NORMAL MODE
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" >>>

" Custom commands (shortcuts) <<<
" Close other buffers and keep only the current one:
command! CloseOtherBuffers execute '%bwipe|edit #|normal `"'
nnoremap <silent> c, :CloseOtherBuffers<CR>| " Close other buffers and keep only the current one

function! MarkDelete()
    call inputsave()
    let l:mark = input("Mark to delele: ")
    call inputrestore()
    execute 'delmark '.l:mark
endfunction
nnoremap <Leader>md :call MarkDelete()<CR>| " (marks) delete single
nnoremap <Leader>m :Marks<CR>| " (marks) show all
nnoremap <Leader>mda :delmarks!<CR>| " (marks) delete all

nnoremap <leader>fp :call fzf#run(fzf#vim#with_preview({'options': '--reverse --prompt "Select file from my PERSONAL notes directory: "', 'down': 20, 'dir': '/storage/docs/notes/personal', 'sink': 'e' }))<CR>| " open file from my PERSONAL notes directory
nnoremap <leader>fw :call fzf#run(fzf#vim#with_preview({'options': '--reverse --prompt "Select file from my WORK notes directory: "', 'down': 20, 'dir': '/storage/docs/notes/work', 'sink': 'e' }))<CR>| " open file from my WORK notes directory

command! -bang -nargs=* Zettel call fzf#vim#grep( 'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '/storage/docs/notes/zettelkasten/cards'}), <bang>0)
nnoremap <F11> :Zettel()<CR>| " function key: open zettelkasten notes searching by word

command! -bang -nargs=* QuickNotes call fzf#vim#grep( 'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '/storage/docs/notes/quick'}), <bang>0)

command! -bang -nargs=* TaskCard call fzf#vim#grep( 'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '/storage/docs/notes/tasks'}), <bang>0)
nnoremap <F12> :TaskCard()<CR>| " function key: open task cards searching by word

nnoremap <leader>fn :QuickNotes()<CR>| " open quicknotes searching by word
nnoremap <leader>cn :!create-quick-note.sh<CR> | " create a quicknote
nnoremap <leader>cz :!create-zettelkasten.sh<CR> | " create a zettelkasten
nnoremap <leader>ct :!create-task-card.sh<CR> | " create a task card

function! ReloadVimConfig()
    execute 'w!'
    execute 'source ~/.vimrc'
    execute 'silent !tmux list-clients -F "\#{client_name}" | xargs -n1 -I{} tmux display-message -c {} "Vim configuration successfully reloaded."'
endfunction
nnoremap <leader>rl :call ReloadVimConfig()<CR>| " reload vim configuration (.vimrc)

command! Regclear for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor | " (registers) cleans all vim registers

command! GetHLG echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') | " show the highlight group of the token under your cursor, so that you could e.g. customize it

nnoremap <silent> <F3> :Goyo<CR>| " function key: toggle goyo distraction-free mode

noremap <Leader>y "+y | " copy to system clipboard
noremap <Leader>p "+p | " paste from system clipboard

nnoremap <Leader>u :!update-notes.sh<CR> | " update-notes (github/devops/bin/update-notes.sh)
nnoremap <Leader>r :!update-reminders.sh<CR> | " update-reminders (github/devops/bin/update-reminders.sh)
nnoremap <leader>sc :!show-calendar.sh<CR>| " show calendar (github/devops/bin/show-calendar.sh)


" Git commands
nnoremap <Leader>gs :!git status && lock-terminal-for-input.sh<CR> | " (git) status
nnoremap <Leader>gl :!git glog && lock-terminal-for-input.sh<CR> | " (git) log

" reference: https://www.reddit.com/r/vim/comments/i50pce/how_to_show_commit_that_introduced_current_line
map <silent><Leader>gc :call setbufvar(winbufnr(popup_atcursor(systemlist("cd " . shellescape(fnamemodify(resolve(expand('%:p')), ":h")) . " && git log --no-merges -n 1 -L " . shellescape(line("v") . "," . line(".") . ":" .  resolve(expand("%:p")))), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")<CR> | " (git) show commit that introduced current line in vim

" Run git blame on current file
function! GitBlame()
  :silent execute '!git blame %:p'
  " Fix empty vim window by forcing a redraw
  :redraw!
endfu
nnoremap <leader>gb :call GitBlame()<cr>| " (git) blame current file


nnoremap <Leader>hc :set cuc!<CR> | " toggle highlight current column identation
nnoremap <Leader>hl :set cursorline!<CR> | " toggle highlight current line

" allow moving current line or visual selection up or down (works in visual and insert mode)
nnoremap <c-j> :m .+1<CR>== | "(movement) move current line or selection down
nnoremap <c-k> :m .-2<CR>== | "(movement) move current line or selection up
" TODO: there is a bug on visual selection that makes it sometimes getter more than the current selection when used multiple times
vnoremap <c-j> :m '>+1<CR>gv=gv | "(movement) (VISUAL) move current selection down
vnoremap <c-k> :m '<-2<CR>gv=gv | "(movement) (VISUAL) move current selection up
inoremap <c-j> <Esc>:m .+1<CR>==I | "(movement) (INSERT) move current line down
inoremap <c-k> <Esc>:m .-2<CR>==I | "(movement) (INSERT) move current line up

function! MoveVisualSelectionToFile()
  " copy current visual selection to x register
  normal gv"xy

  let l:defaultFilename = '/tmp/copied.txt'

  call inputsave()
  let l:filename = input('Enter filename (leave it blank to copy to standard location "' . l:defaultFilename .  '"): ')
  call inputrestore()

  try
    " save the x register contents into file
    if l:filename == ''
      call writefile(split(getreg('x'), '\n'), l:defaultFilename, 'a')
    else
      call writefile(split(getreg('x'), '\n'), l:filename, 'a')
    endif
  catch /.*/
    echo "\nCaught error: " . v:exception . '. Here are the local variables:'
    echo l:
    echo "\nNothing will be done, aborting."
    return
  endtry

  " delete current visual selection
  normal gvd
endfunction
vnoremap <leader>ble :call MoveVisualSelectionToFile()<CR>| "(VISUAL) copy current selection to file



" >>>

" Vim event hooks <<<
augroup eventhooks
	autocmd!
	" Before saving a file, deletes any trailing whitespace at the end of each line.
	" If no trailing whitespace is found no change occurs, and the e flag means no error is displayed.
	autocmd BufWritePre * :%s/\s\+$//e

	" After saving a file, display a notification:
	autocmd BufWritePost * silent! !tmux list-clients -F "\#{client_name}" | xargs -n1 -I{} tmux display-message -c {} "File %:p saved."

	" When opening a new buffer, if it has no filetype defaults to text
	autocmd BufEnter * if &filetype == "" | setlocal filetype=text | endif

	" Return to last edit position when opening files (You want this!)
	autocmd BufReadPost *
		    \ if line("'\"") > 0 && line("'\"") <= line("$") |
		    \   exe "normal! g`\"" |
		    \ endif

	" Expands on what vim considers as a markdown filetype
	autocmd BufNewFile,BufFilePre,BufRead *.md,*.markdown,*.mmd set filetype=markdown

	" Redraw the screen to clean artifacts
	" FIXME: this is not the ideal solution: it makes the screen to blink,
	"        is too slow and inefficient, so I better find a better solution
	"        (which consists on discovering which plugin is causing the issue and disabling it):
	autocmd CursorMoved,CursorMovedI * :redraw!
augroup END
" >>>

" Abbreviations <<<
iabbrev apar ()<Left>| " abbreviation: matching parenthesis
iabbrev af ''<Left><Left>f<Right>| " abbreviation: python fstring
" >>>

" PLUGIN CONFIGURATIONS <<<

" FZF <<<
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

function! s:quickfix_toggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! s:remove_quickfix_item()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction

function! s:quickfix_to_filename(qf) abort
  for i in range(len(a:qf.items))
    let d = a:qf.items[i]
    if bufexists(d.bufnr)
      let d.filename = fnamemodify(bufname(d.bufnr), ':p')
    endif
    silent! call remove(d, 'bufnr')
    let a:qf.items[i] = d
  endfor
  return a:qf
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

command! RemoveQuickFixItem :call s:remove_quickfix_item()
command! ToggleQuickfix :call s:quickfix_toggle()
command! ClearQuickfix cexpr []
command! -bar -nargs=1 -complete=file WriteQuickfix call writefile([js_encode(s:quickfix_to_filename(getqflist({'all': 1})))], <f-args>)
command! -bar -nargs=1 -complete=file ReadQuickfix call setqflist([], ' ', js_decode(get(readfile(<f-args>), 0, '')))

" TODO:  fix the command below, it is not working
" Below customizes the Rg command so that we can pass optional flags to it. E.g.: :Rg myterm -g '*.md'
" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . <q-args>, 1, <bang>0)

nnoremap <silent> <F10> :ToggleQuickfix<Cr>| " function key: toggle quickfix
nnoremap <silent> <Leader>qn :cn<Cr>| " quickfix: go to next item
nnoremap <silent> <Leader>qp :cp<Cr>| " quickfix: go to previous item
nnoremap <silent> <Leader>qf :cfirst<Cr>| " quickfix: go to first item
nnoremap <silent> <Leader>ql :clast<Cr>| " quickfix: go to last item
nnoremap <silent> <Leader>qP :colder<Cr>| " quickfix: go to older quickfix list
nnoremap <silent> <Leader>qN :cnewer<Cr>| " quickfix: go to newer quickfix list
nnoremap <silent> <Leader>qd :ClearQuickfix<Cr>| " quickfix: clear
nnoremap <silent> <Leader>qs :WriteQuickfix ~/.vim-quickfix-history/quickfix.json<Cr>| " quickfix: save to file
nnoremap <silent> <Leader>qr :ReadQuickfix ~/.vim-quickfix-history/quickfix.json \|:copen<Cr>| " quickfix: restore from file
augroup quickfixconf
	autocmd!
	autocmd FileType qf map <buffer> <Cr> :.cc<Cr>| " quickfix: go to selected item on quickfix window
	autocmd FileType qf map <buffer> dd :RemoveQuickFixItem<Cr>| " quickfix: delete current selected item from list
augroup END

nnoremap <silent> <Leader>lP :lolder<Cr>| " location list: go to older list
nnoremap <silent> <Leader>lN :lnewer<Cr>| " location list: go to newer list

let g:fzf_files_options = '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
nnoremap <C-f> :Files<Cr>| " fzf: select file by name
nnoremap <C-g> :Rg<Cr>| " fzf: select file by contents
nnoremap <C-b> :Buffers<Cr>| " fzf: select open buffers
nnoremap <C-d> :Commands<Cr>| " fzf: select commands
nnoremap <Leader>w :Windows<Cr>| " fzf/windows:  select open windows
nnoremap <C-t> :Tags<Cr>| " fzf: search for tag (ctag) in file - search class, variable, etc...
nnoremap <silent> <Leader>bd :bd!<Cr>| " fzf: buffer delete - deletes the buffer from the session, but keeps marks and the jump list
nnoremap <silent> <Leader>bw :bw!<Cr>| " fzf: buffer wipe - deletes all traces from the buffer on the session (marks, jump list, etc...)
" >>>

" SNIPMATE <<<
" If I ever need to customize anything on snipmate, enable the line below
let g:snipMate = { 'snippet_version' : 1 }
" >>>

" VISTA <<<
nmap <F7> :Vista!!<CR>| " function key: Toggle ctags sidebar to easily navigate on code
let g:vista_default_executive = 'ctags'
let g:vista_executive_for = {
    \ 'python': 'ale',
    \ 'markdown': 'toc',
    \ }
let g:vista_highlight_whole_line = 1

augroup vistaconf
	autocmd!
	autocmd FileType vista,vista_kind nnoremap <buffer> <silent> <F8> :<c-u>call vista#finder#fzf#Run()<CR>| " function key: vista search for symbol (function, variable, import)
	autocmd FileType python nnoremap <buffer> <silent> <F8> :Vista finder ale<CR>| " function key: vista search for symbol (function, variable, import)
	autocmd FileType markdown nnoremap <buffer> <silent> <F8> :Vista finder<CR>| " function key: vista search for symbol (function, variable, import)
augroup END

" >>>

" VIM-PYENV <<<
" Dont auto activate on start (to avoid the system pyenv error)
let g:pyenv#auto_activate=0
" >>>

" JEDI-VIM <<<
if jedi#init_python()
  function! s:jedi_auto_force_py_version() abort
    let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
endif
" >>>

" DEOPLETE <<<
let g:deoplete#enable_at_startup = 1
" >>>

" ALE <<<
" For this to work, I must install these requirements on all my virtualenvs: https://raw.githubusercontent.com/tiagoprn/devops/master/python/requirements.vim
" More config options for python: https://github.com/dense-analysis/ale/blob/master/doc/ale-python.txt
" let g:ale_virtualenv_dir_names = [] " Disable auto-detection of virtualenvironments, so environment variable ${VIRTUAL_ENV} is always used
let g:ale_linters = {'*': [], 'yaml': ['yamllint'], 'vim': ['vint'], 'python': ['pyls', 'pylint'], 'terraform': ['tflint']} " flake8, pycodestyle, bandit, mypy, etc...
let g:ale_fixers = {'*': [], 'python': ['black', 'isort']}

augroup deopleteconfig
	autocmd!
	" autocmd FileType python let g:ale_python_pylint_options = '--rcfile ~/.pylintrc'
	autocmd FileType python let g:ale_python_pylint_options = '--rcfile .pylintrc'
	autocmd FileType python let g:ale_python_isort_options = '-m 3 -tc -y'
	autocmd FileType python let g:ale_python_black_options = '-S -t py37 -l 79  --exclude "/(\.git|\.venv|env|venv|build|dist)/"'
	" https://yamllint.readthedocs.io/en/stable/configuration.html
	autocmd FileType yaml let g:ale_yaml_yamllint_options='-d "{extends: relaxed, rules: {line-length: disable}}"'
augroup END

" Customization
let g:ale_completion_enabled = 0
let g:ale_set_balloons = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'ER'
let g:ale_sign_warning = 'WA'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] %s [%linter%]'
let g:ale_list_window_size = 5
let g:ale_set_loclist = 0  " disable location list
let g:ale_set_quickfix = 1  " enable quickfix
" Linter and Fixer behavior:
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
" Overriding most ale lint events:
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
"Remapping to manually trigger ALE functions:
nnoremap <silent> <leader>ad :ALEInfo<CR>| " (python-ale) show ALE configuration information for the current file - useful for debugging
nnoremap <silent> <leader>afs :ALEFixSuggest<CR>| " (python-ale) run ALE Fixer suggestion (black)
nnoremap <silent> <leader>af :ALEFix<CR>| " (python-ale) run ALE Fixer (black)
nnoremap <silent> <leader>al :ALELint<CR>| " (python-ale) run ALE Linter (pylint)
nnoremap <silent> <leader>ar :ALEReset<CR>| " (python-ale) remove all problems reported by ALE for all buffers.
nnoremap <silent> <leader>an :ALENextWrap<CR>| " (python-ale) go to next error in file
nnoremap <silent> <leader>ap :ALEPreviousWrap<CR>| " (python-ale) go to previous error in file
nnoremap <silent> <leader>ai :ALEHover<CR>| " (python-ale) show information about current word under cursor object
nnoremap <silent> <leader>gd :ALEGoToDefinition<CR>| " (python-ale) go to definition
nnoremap <silent> <leader>fr :ALEFindReferences<CR>| " (python-ale) find references for word under cursor (In ALEPreviewWindow, use ':cbuffer' to copy to quickfix or ':lbuffer' to copy to location list)
" >>>

" Goyo <<<
let g:goyo_width='80'
let g:goyo_height='85%'
let g:goyo_linenr=0

augroup goyoconfig
	autocmd!
	autocmd! User GoyoEnter Limelight
	autocmd! User GoyoLeave Limelight!
augroup END

" >>>

" AGRICULTURE <<<
let g:agriculture#rg_options = '--case-sensitive --hidden --glob "!.git"'
let g:agriculture#disable_smart_quoting = 1

nmap <Leader>/ <Plug>RgRawSearch
vmap <Leader>/ <Plug>RgRawVisualSelection
nmap <Leader>* <Plug>RgRawWordUnderCursor
" >>>

" SLIME <<<
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": "session_name:window.pane"}
" >>>

" LEADERF <<<
inoremap <c-s><c-n> <c-\><c-o>:Leaderf snippet --popup<CR> | " (INSERT) (leaderf) insert code snippet on cursor
nnoremap <Leader>J :Leaderf jumps --popup<CR> | " (jumps) (leaderf) interactive jump selection
nnoremap <Leader>ch :Leaderf cmdHistory --popup<CR> | " (leaderf) search on commands history
nnoremap <Leader>sh :Leaderf searchHistory --popup<CR> | " (leaderf) redo a search from search history
nnoremap <Leader>c :Leaderf command --popup<CR> | " (leaderf) Run command from vim command "palette"

let g:Lf_PreviewResult = get(g:, 'Lf_PreviewResult', {})
" >>>

" VIM-PYTHONSENSE <<<
let g:is_pythonsense_alternate_motion_keymaps = 1
"  >>>

" MARVIN <<<
let g:marvim_store = '/storage/src/dot_files/.vim/macros' " change store place.
let g:marvim_find_key = '<Space>mf' | " (macros) find macro (use tab to navigate between available ones)
let g:marvim_store_key = '<Space>ms' | " (macros) save current macro (IMPORTANT: it must be on 'a' register)
let g:marvim_register = 'a'       " change used register from 'q'
let g:marvim_prefix = 0           " disable default syntax based prefix
">>>

" Global autocmds and miscelaneus <<<
augroup pythonsenseconfig
	autocmd!
	autocmd VimResized * wincmd =  " (windows) resize vim splits proportionally when the window that contains vim is resized
	" Automatic reloading of .vimrc
	autocmd! bufwritepost .vimrc source %
augroup END

" sets a gray margin on column 80
"" set colorcolumn=80
" past column 80, the background will be a different color
"" let &colorcolumn=join(range(120,9999),",")


" Update buffer if changed outside current edit session
" when cursor not moved for updatetime miliseconds, trigger autoread below.
" NOTE: if vim becomes to unstable, change below to 1000 ms.
" set updatetime=750
" set autoread
" augroup autoRead
"     autocmd!
"     autocmd CursorHold,CursorHoldI * silent! checktime
" augroup END

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

augroup trailingconfig
	autocmd!
	autocmd BufWrite *.py :call DeleteTrailingWS()
	autocmd BufWrite *.coffee :call DeleteTrailingWS()
	" a quickfix window opens with a 10-line height, even when the number of errors
	" is 1 or 2. I think it's a waste of window space. So I wrote the following
	" code in my vimrc. With it, a quickfix window height is automatically adjusted
	" to fit its contents (maximum 5 lines).
	" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
	autocmd FileType qf call AdjustWindowHeight(5, 8)
augroup END

function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" Convert md to another format
function! ConvertMarkdownToFormat(extension)
  " Below is to debug the command execution
  " :execute '!echo pandoc % -o %:r.' . a:extension
  :silent execute '!pandoc % -o %:r.' . a:extension . ' && xdg-open %:r.' . a:extension
  " Fix empty vim window by forcing a redraw
  :redraw!
endfu

augroup convertmarkdownconf
	autocmd!
	autocmd FileType markdown nnoremap <leader>pp :call ConvertMarkdownToFormat('pdf')<cr>| " pandoc: convert markdown to pdf
	autocmd FileType markdown nnoremap <leader>ph :call ConvertMarkdownToFormat('html')<cr>| " pandoc: convert markdown to html
augroup END


" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-z> :ZoomToggle<CR>| " (windows) toggle zoom on current window

" " use the X clipboard for copy/paste
" if has('clipboard')
"     if has('unnamedplus')  " When possible use + register for copy-paste
"         set clipboard=unnamed,unnamedplus
"     else         " On mac and Windows, use * register for copy-paste
"         set clipboard=unnamed
"     endif
" endif

" Below adds support for a custom .vimrc per project (must be at the project root)
set secure
if filereadable(expand(printf('%s/%s', getcwd(), '.vimrc.project')))
    exec printf('source %s/%s', getcwd(), '.vimrc.project')
endif

" Basically, when Space is pressed (in normal mode), a sort of "fast
" navigation" mode is triggered, where j and k move 10 lines instead of just
" one. Another press of Space exits the mode.
nnoremap <Space>j 20j<CR>| " fast scroll down
nnoremap <Space>k 20k<CR>| " fast scroll up

nnoremap <silent> <F5> :set rnu!<CR>| " function key: toggle relative line numbering


function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &foldcolumn + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let chunks = split(line, "\t", 1)
    let line = join(map(chunks[:-2], 'v:val . repeat(" ", &tabstop - strwidth(v:val) % &tabstop)'), '') . chunks[-1]

    let line = strpart(line, 0, windowwidth - 2 - len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 1
    return line . '...' . repeat(' ', fillcharcount) . foldedlinecount . ' '
endfunction
set foldexpr=MyFoldText()
">>>

">>>

" CHEATSHEET <<<

"" repetitions

" .| " repeat the last command
" 5p| " paste text 5 times
" 3yy| " copy current line and the 2 ones below it
" 2f [char]| " go to the second occurence of char in line
" 10k| " moves 10 lines up
" 5j| " move 5 lines down

"" movement

" h  | "  (movement)   left
" j  | "  (movement)   down
" k  | "  (movement)   up
" l  | "  (movement)   right
" gj | "  (movement)   move down on soft wrapped line
" gk | "  (movement)   move up on soft wrapped line
" w  | "  (movement)   next word
" )  | "  (movement)   next sentence
" }  | "  (movement)   next paragraph
" b  | "  (movement)   beginning of current word / previous word
" ge | "  (movement)   end of the previous word
" e  | "  (movement)   end of current word / end of next word
" ^  | "  (movement)   first non-blank character of a line
" f [char]  | "  (movement)   go to specific char in line, ';' to go to the next occurrence of it
" t [char]  | "  (movement)   go to one character previous/before specific char in line, ';' to go to the next occurrence of it
" H  | " (movement) high on the viewport
" M  | " (movement) middle on the viewport
" L  | " (movement) low on the viewport
" zz  | "  (movement)   without moving the cursor, put the current line on the middle of the screen (viewport).
" zt  | "  (movement)   without moving the cursor, put the current line on the top of the screen (viewport).
" zb  | "  (movement)   without moving the cursor, put the current line on the bottom of the screen (viewport).
" g; | " go to the previous place you were editing on the current file
" ctrl+e | " (movement) move one line down on viewport
" ctrl+y | " (movement) move one line up on viewport
" ctrl+h | " move current character left
" ctrl+l | " move current character right

"" snippets
" <word><tab>| " expand snippet

"" python specific
"(python-pyenv) Activate pyenv | " PyenvActivate <pyenv>
"(python-pyenv) Deactivate pyenv | " PyenvDeactivate

"" others

" ctrl+[ | "  go to visual mode
" ctrl+o | "  go to normal mode to execute just one command and go back to insert mode
" 80i*<esc> | "  (in visual mode - do not start with ':' - this will insert the * character 80 times on the current cursor position)
" 3i`<esc> |"  (in visual mode - do not start with ':' - this will insert the backstick character 3 times on the current cursor position)
" o | "  insert blank line below cursor
" O | "  insert blank line above cursor
" A | "  go to end of line and enter insert mode
" I | "  go to beginning of line and enter insert mode
" C | "  Delete until end of the line and enter insert mode
" D | "  Delete until end of the line
" :%s/ /\r/g | " replace spaces for <enter>
" :%s/old/new/gc | " replace asking for confirmation on each occurence
" :%s/https.*/[&]()/g | " (replace) find all urls/links with regex and replace them with markdown syntax - the '&' does the magic and inserts the matched text
" shift+v  | "  select a whole line
" <control>, h  | "  move current line/selection to the left
" <control>, j  | "  move current line/selection down
" <control>, k  | "  move current line/selection up
" <control>, l  | "  move current line/selection to the right
" <control>, left or right | " cycle through open buffers
" :w !sudo tee % | " save file as sudo when you forgot to do that
" :set et|retab | " replaces tab with 4 spaces
" gcc | " comment/uncomment selection
" zR | " open all folds
" zM | " close all folds
" zo | " open current fold
" zc | " close current fold
" za | " toggle current fold
" zd | " delete current fold
" "<register-name><command> | " (registers)       syntax format
" [ " ] | " (registers)    default/unnamed : updates whenever you delete or yank
" [ - ] | " (registers)    small delete: deleted text smaller than one line
" [ 0..9 ] | " (registers)    numbered: 0 - latest yank or big delete (greater than one line), 1..9 - big deletes or changes
" [ a..z ] | " (registers)    named: changing value replaces register contents (those are also used for the macros!)
" [ A..Z ] | " (registers)    named: changing value appends to register
" [ _ ] | " (registers)    black hole
" [ / ] | " (registers)    last search pattern
" "+yy | " (registers) copy current line to system clipboard (change + for * to primary 'mouse " selection' clipboard)
" "+veey | " (registers) copy next 2 words to system clipboard
" "+p | " (registers) paste system clipboard contents
" "ayy | " (registers) copy current line to register a
" "Ayy | " (registers) append current line to register a (use a capital letter to append to a register)
" "ap | " (registers) paste register a contents
" :let @z = "value" | " (registers) set register 'z' value
" :let @z = "" | " (registers) clean register 'z' value
" :let @x = @z | " (registers) set register 'x' values as register 'z' value
" :reg | " (registers) see all registers' contents
" <C-r>register-name | " (registers) paste from register on insert or command mode.
" :verbose map | " (mapping) show all defined mappings in vim - and where the mappings are defined
" :map | " (mapping) show all defined mappings in vim
" :vmap <key> | " (mapping) show if <key> is mapped
" csw` | " (surround) surround current word with ` - you can use [({ instead of `
" ds` | " (surround) delete ` surrounding current word - you can use [({ instead of `
" S` (on visual selection) | " (surround) surround current visual selection with ` - you can use [({ instead of ` (S is the 'current text selection' vim object)
" ys2w` | " (surround) surround next 2 words with ` - you can use [({ instead of `
" ystA` | " (surround) surround until letter A with ` - you can use [({ instead of `
" <Cr> | " fzf: open file on current window
" <C-s> | " fzf/windows: open file on horizontal split
" <C-v> | " fzf/windows: open file on vertical split
" <tab> | " fzf/quickfix: select item to go to quickfix
" (VISUAL/NORMAL) <leader>/ | " fzf/rg: search for visual selection on current folder
" (VISUAL) <leader>* | " fzf/rg: search for current word on current folder
" <ctrl+a> | " fzf/quickfix: select all items to go to quickfix
" <ctrl+q> | " fzf/quickfix: copy selected items to quickfix
" :Rg 'text' -g '*.py' | " search with rg (<ctrl+a> or <tab> to select, <ctrl+q> to copy to quickfix)
" :cdo[!] {cmd} | update | " (quickfix) Execute {cmd} in EACH VALID ENTRY in the quickfix list and save all files
" :cfdo[!] {cmd} | update | " (quickfix) Execute {cmd} in EACH FILE in the quickfix list and save all files. E.g. :cfdo[!] %s/old/new/g | update
" :chistory | " (quickfix) show your quickfix lists
" :ld[o][!] {cmd} | " (location-list) Execute {cmd} in each valid entry in the location list for the current window.
" :lfdo[!] {cmd} | " (location-list) Execute {cmd} in each file in the location list for the current window.
" :lhistory | " (location-list) show your location lists
" :gf | " open text file/directory under cursor (works 'magically' if there is a file/directory under the current cursor)
" :gF | " open text file/directory under cursor on the line (works 'magically' if there is a file/directory under the current cursor. E.g. `file.py:75`)
" :gx | " open file/directory under cursor with the corresponding application (xdg-open like)
" <C-c>, <C-c> (meaning: Hold <Ctrl>, then 'cc') | " (slime) copy cursor text to tmux pane - e.g. useful specially with ipython, pgcli, and other REPL/dynamic interpreters
" <C-c>, v | " (slime) configure copy to tmux pane (session:window.pane) - e.g. useful specially with ipython, pgcli, and other REPL/dynamic interpreters
" :SlimeConfig | " (slime) configure copy to tmux pane (session:window.pane) - e.g. useful specially with ipython, pgcli, and other REPL/dynamic interpreters
" Vjjjj :normal @a | " (macros) run macro 'a' on selected lines
" :set spell! | " (spellcheck) toggle spell checking
" ]s | " (spellcheck) jump to the next misspelled word
" [s | " (spellcheck) jump to the previous misspelled word
" z= | " (spellcheck) bring up the suggested replacements
" zg | " (spellcheck) add the word under the cursor to the dictionary
" zw | " (spellcheck) undo and remove the word from the dictionary
" :args /full/path/**/*.txt | " (global search/replace) 01 - populate args list with a list of files (recursively)
" :argdo %s/old/new/g | " (global search/replace) 02 - replace on all files on the args list
" :argdo update | " (global search/replace) 03 - save all files on the args list
" :wn | " (global search/replace) 04 - save current file and move to the next one in the args list
" :read !<command> | " run external command and insert its' stdout on current position
" (SELECTION) :write !<command> | " run external command (e.g. python, etc...) with selection as input.
" (SELECTION) :!<command> | " run external command on selected text. e.g. figlet, column, sort, etc...
" :m' | " (jumps/marks) mark current line (so that it appears on the jump list)
" :ju | " (jumps) show jumps list (the current position has a '>' on the list)
" <ctrl-o> | " (jumps) go to previous jump on jumps list
" <ctrl-i> | " (jumps) go to next jump on jumps list
" :clearjumps | " (jumps) clear the jumps list
" :windo w! | " (windows) save files open on all windows
" :windo e! | " (windows) reload files open on all windows
" <ctrl-]> | " (help) jump to tag under cursor - you can use (jumps) navigation mappings to navigate back and forth between them.
" :g/pattern/d | "  (patterns) remove lines matching pattern
" :g!/pattern/d | " (patterns) remove lines that do NOT match the pattern
" <ctrl-a> | " (numbers) increment the next number on the line
" <ctrl-x> | " (numbers) decrement the next number on the line
" (VISUAL)gv | " re-select/redo last visual selection
" g: | " (python/motions) print (echo) current semantic location (e.g. '(class:)Foo > (def:)bar')
" ]k | " (python/motions) Move (forward) to the beginning of the next Python class.
" ]K | " (python/motions) Move (forward) to the end of the current Python class.
" [k | " (python/motions) Move (backward) to beginning of the current Python class (or beginning of the previous Python class if not currently in a class or already at the beginning of a class).
" [K | " (python/motions) Move (backward) to end of the previous Python class.
" ]f | " (python/motions) Move (forward) to the beginning of the next Python method or function.
" ]F | " (python/motions) Move (forward) to the end of the current Python method or function.
" [f | " (python/motions) Move (backward) to the beginning of the current Python method or function (or to the beginning of the previous method or function if not currently in a method/function or already at the beginning of a method/function).
" [F | " (python/motions) Move (backward) to the end of the previous Python method or function.
" f | " (python/text-objects) function  (e.g. actions: cif, vif, caf, vaf)
" c | " (python/text-objects) class (e.g. actions: cic, vic, cac, vac)
" d | " (python/text-objects) docstring (e.g. actions: cid, vid, cad, vad)
" >> or 3>> | " (NORMAL) indent (one line or e.g. 3 lines)
" << or 3<< | " (NORMAL) deindent (one line or e.g. 3 lines)

" <C>r | " (leaderf window) alternate between regex/fuzzy search
" <C>j | " (leaderf window) navigate down
" <C>r | " (leaderf window) navigate up
" <C>c | " (leaderf window) close window

" TODO: move the cheatsheet from vim.CHEATSHEET on the dot_files repo to here, to be browsable with rofi.
" >>>


