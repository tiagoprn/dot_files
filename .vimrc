" _   _                                    _             _
"| |_(_) __ _  __ _  ___  _ __  _ __ _ __ ( )___  __   _(_)_ __ ___  _ __ ___
"| __| |/ _` |/ _` |/ _ \| '_ \| '__| '_ \|// __| \ \ / / | '_ ` _ \| '__/ __|
"| |_| | (_| | (_| | (_) | |_) | |  | | | | \__ \  \ V /| | | | | | | | | (__
" \__|_|\__,_|\__, |\___/| .__/|_|  |_| |_| |___/   \_/ |_|_| |_| |_|_|  \___|
"             |___/      |_|
"
"------------------------------------------------------------------------
"
" I use VUNDLE "package manager" and its plugins.

" we need to make sure that vim is not attempting to retain compatibility with
" vi, its predecessor. This is a vundle requirement.
set nocompatible

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" This is the Vundle package, which can be found on GitHub.
" For GitHub repos, you specify plugins using the
" 'user/repository' format
Plugin 'gmarik/vundle'

" We could also add repositories with a ".git" extension
Plugin 'scrooloose/nerdtree.git'
Plugin 'jistr/vim-nerdtree-tabs'

" To get plugins from Vim Scripts, you can reference the plugin
" by name as it appears on the site

" CTRLSpace
Plugin 'vim-ctrlspace/vim-ctrlspace'

" A light and configurable statusline/tabline for Vim
Plugin 'itchyny/lightline.vim'

" vim-bookmarks
Plugin 'MattesGroeger/vim-bookmarks'

"fzf plugins
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" snippets support plugins
"" Track the engine.
Plugin 'SirVer/ultisnips'

"" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

"" Add specific actions for directories creating a .vimdir file on a specific directory (e.g. /storages/docs/notes)
Plugin 'chazy/dirsettings'

""" Do not use <tab> with UltiSnip if you use https://github.com/Valloric/YouCompleteMe.

"""Changing the directory where to find the snippets
let g:UltiSnipsSnippetsDir          = $HOME.'/.vim/UltiSnips/'
let g:UltiSnipsSnippetDirectories   = [ "UltiSnips" ]

""" Show all snippets
let g:UltiSnipsListSnippets="<c-l>"

""" Activate Ultisnips on word
let g:UltiSnipsExpandTrigger="<tab>"

""" Go to next snippet variable (also called "tabstop")
let g:UltiSnipsJumpForwardTrigger="<tab>"

""" Go to previous snippet variable. The "s-" below means the Shift key
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

""" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"" Now we can turn our filetype functionality back on
filetype plugin indent on


"------------------------------------------------------------------------
" MY CUSTOM VIM CONFIGURATIONS

" below for the ctrl-space plugin:
set hidden
set showtabline=0

" Changing the ruler position
set relativenumber

" We also want to turn off the default "filetype" controls for now because the
" way that vim caches filetype rules at runtime interferes with the way that
" vundle alters the runtime environment.
filetype off

" the File, Open dialog defaults to the current file's directory.
set browsedir=buffer

" Auto-reload files
set autoread
" Below triggers autoread when changing buffers inside while inside vim
au FocusGained,BufEnter * :checktime
syntax on

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Disable backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" General settings
set title
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*~
autocmd VimResized * wincmd =  " resize vim splits proportionally when the window that contains vim is resized

" Better Searching
set hlsearch             " highlight searches
set incsearch            " show search matches while you type
set ignorecase           " ignore case on searching by default
set smartcase            " uppercase characters will be taken into account
" ENTER key on visual mode de-highlights current highlighted search
nnoremap <CR> :nohlsearch<cr>

" move vertically by visual line (when "setwrap" is settled)
nnoremap j gj
nnoremap k gk

" Then, when in insert mode, ready to paste, if you press <F2>, Vim will switch
" to paste mode, which will not try to ident code when you paste it from
" another app, like the browser or a text editor.
set pastetoggle=<F2>

" Rebind <Leader> key
let mapleader = ","  " the <Leader> combination (in visual mode) will so be: ','
" Example (easier moving between tabs):
map <Leader>m <esc>:tabprevious<CR>
map <Leader>n <esc>:tabnext<CR>

" Map <,all> to select all text in the file:
map <Leader>all <esc>gg0vG$<CR>

" Height of the command bar
set cmdheight=2

" LINES CONFIGURATION
set number  " show line numbers
set winwidth=80  "minimum window width
set textwidth=99   " maximum line length
set formatoptions+=t  " automatically wrap text when typing
" set formatoptions-=t   " don't automatically wrap text when typing
set formatoptions-=l  " Force line wrapping
filetype plugin indent on
au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79

" sets a gray margin on column 80
"" set colorcolumn=80
" past column 80, the background will be a different color
"" let &colorcolumn=join(range(120,9999),",")

" Useful settings
set history=700
set undolevels=700

" switch window splits more easily
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" automaticially change window's cwd to file's dir
set autochdir

" TABs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Show special chars below
set listchars=tab:→_,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
" Just show special chars on visual mode, on insert mode they are disabled
au BufEnter,InsertLeave * set list
au InsertEnter * set nolist

" Expands on what vim considers as a txt filetype
au BufNewFile,BufFilePre,BufRead *.txt,*.md,*.markdown,*.mmd set filetype=txt

" When opening a new buffer, if it has no filetype defaults to txt
autocmd BufEnter * if &filetype == "" | setlocal filetype=txt | endif

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Remember info about open buffers on close
set viminfo^=%

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Color scheme (must be in ~/.vim/colors)
set t_Co=256
color city-lights

" font
set anti gfn=Hack\ Regular\ 11
set guifont=Hack\ Regular\ 11

" Always show the status line
set laststatus=2
" Format the status line
" set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Key remappings
" easy toggle between windows
nnoremap <Leader>w <C-w>w

" If you like long lines with line wrapping enabled, this solves the problem
" that pressing down jumpes your cursor “over” the current line to the next
" line. It changes behaviour so that it jumps to the next row in the editor
" (much more natural):
nnoremap j gj
nnoremap k gk

"--------------------------------------------------
" CLIPBOARD BEHAVIOR (both work in visual mode)
" vmap <C-y> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
" nmap <C-p> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p")")")"))
vnoremap y y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
vnoremap p :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p")")")"))
nmap <C-p> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p")")")"))

" replace the current selection with clipboard contents. Explanation:
" vmap - mapping for visual mode
"_d - delete current selection into black hole register
" P - paste
vmap r "_dP

" d and dd command no more send text to the clipboard (instead, send it to
" the blackhole register)
nnoremap d "_d
nnoremap dd "_dd

"------------------------
" DISABLE ARROW KEYS IN NORMAL MODE
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

"-----------------------------------"
" CUSTOM COMMANDS (SHORTCUTS)

" Show (Ultisnips) snippets list (call with: <VISUAL>:S):
command! -bar -bang S call fzf#vim#snippets({'options': '--ansi --tiebreak=index +m -d "\t"'}, <bang>0)

"----------------------------------"
" VIM EVENT HOOKS "

" Before saving a file, deletes any trailing whitespace at the end of each line.
" If no trailing whitespace is found no change occurs, and the e flag means no error is displayed.
autocmd BufWritePre * :%s/\s\+$//e

" After saving a file, display a notification:
autocmd BufWritePost * silent! !notify-send -a vim "File %:p saved."

"

"--------------------------------------------------
" PLUGIN CONFIGURATIONS

"" NERDTree
" Open a NERDTree automatically when vim starts up if no files were specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" map <CTRL>+n open/close NERDTree
map <C-n> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '\~$']
let NERDTreeShowBookmarks=1

"" vim-bookmarks
nmap <Leader><Leader> <Plug>BookmarkToggle
nmap <Leader>i <Plug>BookmarkAnnotate
nmap <Leader>a <Plug>BookmarkShowAll
nmap <Leader>n <Plug>BookmarkNext
nmap <Leader>p <Plug>BookmarkPrev
nmap <Leader>c <Plug>BookmarkClear
nmap <Leader>x <Plug>BookmarkClearAll

"" tasklist
map <C-t> <Plug>TaskList

"" fzf
" select file by name
nnoremap <C-f> :Files<Cr>
" select file by contents
nnoremap <C-g> :Rg<Cr>

" CTRLSpace
" Sets the minimal height of the plugin window.
let g:CtrlSpaceHeight = 5
let g:CtrlSpaceUseTabline = 1
let g:CtrlSpaceUseArrowsInTerm = 1
let g:CtrlSpaceProjectRootMarkers = [".git", ".hg", ".bzr"]

" lightline specific configuration

let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'readonly': 'MyReadonly',
      \   'modified': 'MyModified',
      \   'filename': 'MyFilename'
      \ },
      \ }

function! MyModified()
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction

function! MyReadonly()
    if &filetype == "help"
        return ""
    elseif &readonly
        return ""
    else
        return ""
    endif
endfunction

function! MyFugitive()
    return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! MyFugitive()
    if exists("*fugitive#head")
        let _ = fugitive#head()
        return strlen(_) ? ''._ : ''
    endif
    return ''
endfunction

function! MyFilename()
    return '' != expand('%:p') ? expand('%:p') : '[No Name]'
endfunction

" tagbar
map <F7> :TagbarToggle<CR>
" let g:tagbar_autoclose = 1

" a quickfix window opens with a 10-line height, even when the number of errors
" is 1 or 2. I think it's a waste of window space. So I wrote the following
" code in my vimrc. With it, a quickfix window height is automatically adjusted
" to fit its contents (maximum 5 lines).
" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
au FileType qf call AdjustWindowHeight(3, 5)
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

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
nnoremap <silent> <C-z> :ZoomToggle<CR>

" use the X clipboard for copy/paste
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif
