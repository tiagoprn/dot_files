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

" Markdown plugins
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" tab completion and documentation
Plugin 'SuperTab'

" search for anything on your code
Plugin 'ack.vim'

" git plugins
Plugin 'fugitive.vim'

" pydoc
Plugin 'pydoc.vim'

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
Plugin 'python-rope/ropevim'

" Support for code snippets
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

" CTRLSpace
Plugin 'szw/vim-ctrlspace'


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

" Rebind <Leader> key
" I like to have it here because it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","  " the <Leader> combination will so be: '\,'
" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

filetype plugin indent on
au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79 " PEP-8 Friendly

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


" Color scheme (must be in ~/.vim/colors)
set t_Co=256
color wombat256mod

" Moving windows
" Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w +
" <movement>:
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h


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

" SuperTab - Autocomplete behavior
au FileType python set omnifunc=pythoncomplete#Complete
set completeopt=menuone,longest,preview

"" Flake8
" remaps the manual file checking to F8
autocmd FileType python map <buffer> <F8> :call Flake8()<CR>
" run the Flake8 check every time you write a Python file
autocmd BufWritePost *.py call Flake8()
" customize the location of your flake8 binary
" let g:flake8_cmd="/opt/strangebin/flake8000"
" Show vim's quickfix
let g:flake8_show_quickfix=1
" customize the height of quick fix window
let g:flake8_quickfix_height=3
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
let g:ropevim_autoimport_modules = ["os", "shutil"]
map <C-c>g :RopeGotoDefinition<CR>
map <C-c>w :RopeFindFileOtherWindow<CR>
map <C-c>f :RopeFindFile<CR>

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

let g:ctrlspace_show_tab_info =1
let g:ctrlspace_show_key_info = 1
let g:ctrlspace_project_root_markers = [".git", ".hg", ".bzr"]


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


