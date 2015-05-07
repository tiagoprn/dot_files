"------------------------------------------------------------------------
" VUNDLE "package manager" and its plugins:

" we need to make sure that vim is not attempting to retain compatibility with
" vi, its predecessor. This is a vundle requirement.
set nocompatible

" We also want to turn off the default "filetype" controls for now because the
" way that vim caches filetype rules at runtime interferes with the way that
" vundle alters the runtime environment.
filetype off

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
Plugin 'Buffergator'

" tab completion and documentation
Plugin 'SuperTab'

" search for anything on your code
Plugin 'ack.vim'

" git plugins
Plugin 'fugitive.vim'

" pydoc
Plugin 'pydoc.vim'

" jedi
Plugin 'davidhalter/jedi-vim.git'

" superseeds pep8 and pyflakes. Covers both
" and also provides a complexity checker.
" You MUST install flake8 to your virtualenv 
" or to your distribution's python.
" pip install flake8 flake8-pep257 pep8-naming
Plugin 'nvie/vim-flake8'

" MiniBufExplorer (useful for pydoc)
Plugin 'fholgado/minibufexpl.vim'

" python auto-completion, go to definition, project search, etc...
" Must be installed to your virtualenv
" or to your distribution's python
" pip install rope ropevim 
" Plugin 'python-rope/ropevim'

" Support for code snippets
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

" CTRLSpace
Plugin 'szw/vim-ctrlspace'

" A light and configurable statusline/tabline for Vim
Plugin 'itchyny/lightline.vim'

" EasyTags + TagBar (for a nice class browser)
" You must have your linux distro 'ctags' package installed for it to work
Plugin 'vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'

" vim-bookmarks
Plugin 'MattesGroeger/vim-bookmarks'

" TaskList - for putting TODO and FIXME under a list
Plugin 'TaskList.vim'

" Now we can turn our filetype functionality back on
filetype plugin indent on


"------------------------------------------------------------------------
" MY CUSTOM VIM CONFIGURATIONS

syntax on

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" General settings
set title
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*~
set incsearch            " show search matches while you type

" move vertically by visual line (when "setwrap" is settled)
nnoremap j gj
nnoremap k gk

" Then, when in insert mode, ready to paste, if you press <F2>, Vim will switch
" to paste mode, which will not try to ident code when you paste it from
" another app, like the browser or a text editor.
set pastetoggle=<F2>

" Rebind <Leader> key
" With a map leader it's possible to do extra key combinations
" like <Leader>w saves the current file
let mapleader = ","  " the <Leader> combination (in visual mode) will so be: ','
" Example (easier moving between tabs):
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

filetype plugin indent on
au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79 " PEP-8 Friendly

" Height of the command bar
set cmdheight=2

" Showing line numbers and length
set number  " show line numbers
set tw=79   " width of document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing

" sets a gray margin on column 80
"" set colorcolumn=80
" past column 80, the background will be a different color
let &colorcolumn=join(range(80,9999),",")

" Useful settings
set history=700
set undolevels=700

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

" Enable vim's native syntax highlight
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

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
color wombat256mod


" font
set anti gfn=Ubuntu\ Mono\ derivative\ Powerline\ 12

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
" PLUGIN CONFIGURATIONS

"" NERDTree
" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" map <CTRL>+n open/close NERDTree
map <C-n> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '\~$']
let NERDTreeShowBookmarks=1

" SuperTab - Autocomplete behavior
au FileType python set omnifunc=pythoncomplete#Complete
set completeopt=menuone,longest,preview

"" Flake8
" remaps the manual file checking to F8
" autocmd FileType python map <buffer> <F8> :call Flake8()<CR>
" run the Flake8 check every time you write a Python file
autocmd BufWritePost *.py call Flake8()
" customize the location of your flake8 binary
" let g:flake8_cmd="/opt/strangebin/flake8000"
" Show vim's quickfix
let g:flake8_show_quickfix=1
" customize the height of quick fix window
let g:flake8_quickfix_height=5
" customize whether the show signs in the gutter
let g:flake8_show_in_gutter=1
" customize whether the show marks in the file
let g:flake8_show_in_file=1
" customize the number of marks to show
let g:flake8_max_markers=100
" customize gutter markers
let flake8_error_marker='ER'     " set error marker
let flake8_warning_marker='WA'   " set warning marker
let flake8_pyflake_marker='FL'   " set PyFlakes warnings
let flake8_complexity_marker='CO' " set McCabe complexity warnings
let flake8_naming_marker='NA'     " set naming warnings
" to use colors defined in the colorscheme
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg

"" ropevim
"  add the name of modules you want to autoimport
" let g:ropevim_autoimport_modules = ["os", "shutil"]
" map <C-c>g :RopeGotoDefinition<CR>
" map <C-c>w :RopeFindFileOtherWindow<CR>
" map <C-c>f :RopeFindFile<CR>
" map <C-a> :RopeCodeAssist<CR>

"" jedi-vim
let g:jedi#goto_assignments_command = "<C-c>g"
let g:jedi#goto_definitions_command = "<C-c>e"
let g:jedi#documentation_command = "<C-c>d"
let g:jedi#usages_command = "<C-c>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<C-c>r"

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

"" snipmate
" CTRL+b to load snippets
imap <C-b> <Plug>snipMateNextOrTrigger
smap <C-b> <Plug>snipMateNextOrTrigger

" CTRLSpace
" Sets the minimal height of the plugin window.
let g:ctrlspace_height = 7

let g:ctrlspace_save_workspace_on_exit = 1
let g:ctrlspace_load_last_workspace_on_start = 1

let g:ctrlspace_show_unnamed = 1

let g:ctrlspace_show_tab_info = 1
let g:ctrlspace_show_key_info = 1
let g:ctrlspace_project_root_markers = [".git", ".hg", ".bzr"]

" lightline specific configuration

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'readonly': 'MyReadonly',
      \   'modified': 'MyModified',
      \   'filename': 'MyFilename'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
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
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
         \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
         \ ('' != MyModified() ? ' ' . MyModified() : '')
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


"--------------------------------------------------
" PYTHON SPECIFIC CONFIGURATION

" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF


