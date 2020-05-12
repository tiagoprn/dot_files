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

" Below is because of:
" https://stackoverflow.com/questions/42377945/vim-adding-cursorshape-support-over-tmux-ssh
set t_SI=[6\ q
set t_SR=[4\ q
set t_EI=[2\ q

" Then, when in insert mode, ready to paste, if you press <F2>, Vim will switch
" to paste mode, which will not try to ident code when you paste it from
" another app, like the browser or a text editor.
" IMPORTANT: DO NOT MOVE this line from here, it must be after nocompatible
"            for the paste toggle to work accordingly.
set pastetoggle=<F4>| " function key: toggle insert paste mode

" Color scheme (must be in ~/.vim/colors)
" set background=dark
colorscheme spacecamp

" font (commented to use the same font as set on the terminal)
" set anti gfn=JetBrains\ Mono\ 11
" set guifont=Fira\ Code\ 11
" set guifont=JetBrains\ Mono\ 11

set tags=~/.cache/vim/ctags

" Auto setup vim make command to run lint
let project_path = system("git rev-parse --show-toplevel | tr -d '\\n'")
let &makeprg = "cd " . project_path . " && make lint"
nnoremap <expr> <F9> '<Esc>:cd ' . project_path . ' \| make<CR>'| " Run linter
nnoremap <F10> <Esc>:cnext<CR>| " Next linter error
nnoremap <F11> <Esc>:cprev<CR>| " Previous linter error

" Set comments as italic
hi comment cterm=italic

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"------------------------------------------------------------------------
" PLUGINS

" This is the Vundle package, which can be found on GitHub.
" For GitHub repos, you specify plugins using the
" 'user/repository' format
Plugin 'gmarik/vundle'

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

" Add specific actions for directories creating a .vimdir file on a specific directory (e.g. /storages/docs/notes)
Plugin 'chazy/dirsettings'

" Better moving of text blocks
Plugin 'matze/vim-move'

" Best support for ctags (requires ctags installed through your distro's package manager)
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'majutsushi/tagbar'

" Undo tree
Plugin 'sjl/gundo.vim'

" Vim color scheme to be used with pywal
Plugin 'dylanaraps/wal.vim'

" language-server support
" (https://bluz71.github.io/2019/10/16/lsp-in-vim-with-the-lsc-plugin.html)
Plugin 'davidhalter/jedi-vim'
Plugin 'lambdalisue/vim-pyenv'
Plugin 'natebosch/vim-lsc'
Plugin 'zchee/deoplete-jedi'
Plugin 'hrsh7th/deoplete-vim-lsc'
Plugin 'ervandew/supertab'
Plugin 'w0rp/ale'

" comment/uncomment blocks of code/text
Plugin 'tpope/vim-commentary'

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

" When the cursor moves outside the viewport of the current window, the buffer scrolls a single
" line to keep the cursor in view. Setting the option below will start the scrolling x lines
" before the border, keeping more context around where you’re working.
set scrolloff=5

nnoremap <C-r> :redraw!<CR>| " redraw screen to cleanup from glitches

" Change the sound beep on errors to screen flashing
set visualbell

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

nnoremap <CR> :nohlsearch<cr>| " de-highlights current highlighted search

nnoremap j gj| " move vertically down by visual line
nnoremap k gk| " move vertically up by visual line

" Rebind <Leader> key
map <SPACE> <leader>

" Leader use example (easier moving between tabs):
map <Leader>m <esc>:tabprevious<CR>| " move to previous tab
map <Leader>n <esc>:tabnext<CR>| " move to next tab

map <Leader>all <esc>gg0vG$<CR>| " select all text in the file

" Height of the command bar
set cmdheight=1

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
au FileType markdown set textwidth=79

" sets a gray margin on column 80
"" set colorcolumn=80
" past column 80, the background will be a different color
"" let &colorcolumn=join(range(120,9999),",")

" Useful settings
set history=700
set undolevels=700

" switch window splits more easily
nnoremap <c-j> <c-w>j| " move to down window
nnoremap <c-k> <c-w>k| " move to up window
nnoremap <c-h> <c-w>h| " move to left window
nnoremap <c-l> <c-w>l| " move to right window

" When on visual selection mode (v), then
" easier moving of code blocks
" Try to go into visual selection mode (v), then
" select several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation| " deindent selection
vnoremap > >gv  " better indentation| " indent selection

" automaticially change window's cwd to file's dir
set autochdir

" TABs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Show special chars below
set listchars=tab:→␣,space:·,nbsp:␣,trail:•,eol:↩,precedes:«,extends:»
" Just show special chars on visual mode, on insert mode they are disabled
au BufEnter,InsertLeave * set list
au InsertEnter * set nolist
" Change color of special chars
" hi SpecialKey ctermfg=red guifg=red

" Expands on what vim considers as a markdown filetype
au BufNewFile,BufFilePre,BufRead *.txt,*.md,*.markdown,*.mmd set filetype=markdown

" When opening a new buffer, if it has no filetype defaults to markdown
autocmd BufEnter * if &filetype == "" | setlocal filetype=markdown | endif

" Update buffer if changed outside current edit session
" when cursor not moved for updatetime miliseconds, trigger autoread below.
" NOTE: if vim becomes to unstable, change below to 1000 ms.
set updatetime=750
set autoread
augroup autoRead
    autocmd!
    autocmd CursorHold,CursorHoldI * silent! checktime
augroup END

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>| " search forwards current highlighted selection
vnoremap <silent> # :call VisualSelection('b')<CR>| " search backwards current highlighted selection

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

" STATUS LINE
"" Always show the status line
set laststatus=2
"" Format the status line
set statusline=
set statusline+=%{ReadonlyStatus()}
set statusline+=%F%m%r%h
set statusline+=\ %y
set statusline+=\ COL:%c
set statusline+=\ WORDS:%{wordcount().words}
" set statusline+=\ \ \ CWD:%{getcwd()}
set statusline+=%=      "left/right separator
set statusline+=\ \ \ %{StatuslineGit()}
set statusline+=\ LINE\:%l/%L(%P)


"" Old functions used by LIGHTLINE
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


" CUSTOM kEY REMAPPINGS
nnoremap <Leader>w <C-w>w| " toggle between windows

nnoremap <Backspace> :bw<Enter>| " Close buffer
nnoremap <leader>q :bp\|bd \#<Enter>| " Close buffer but keep split
nnoremap <leader><Backspace> <C-w>q<Enter>| " Close split but keep buffer

nnoremap <Leader>s :vnew<CR>| " new vertical window split
nnoremap <Leader>S :new<CR>| " new horizontal window split
" session management (below, <BS> means the backspace key,
"                     and <C-D> list existing files through cli completion)
let g:sessions_dir = '~/vim-sessions'
exec 'nnoremap <Leader>ss :mks! ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'| " save current session
exec 'nnoremap <Leader>so :so ' . g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'| " open session

" If you like long lines with line wrapping enabled, this solves the problem
" that pressing down jumpes your cursor “over” the current line to the next
" line. It changes behaviour so that it jumps to the next row in the editor
" (much more natural):
nnoremap j gj| " go down on wrapped line
nnoremap k gk| " go up on wrapped line

" CLIPBOARD BEHAVIOR (both work in visual mode)
vnoremap y y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>| " copy to clipboard
vnoremap p :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p")")")"))| " paste from clipboard
nmap <C-p> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p")")")"))| " paste from clipboard

" vmap - mapping for visual mode
"_d - delete current selection into black hole register
" P - paste
vmap r "_dP| " replace current selection with clipboard contents

" d and dd command no more send text to the clipboard (instead, send it to
" the blackhole register)
nnoremap d "_d
nnoremap dd "_dd

" DISABLE ARROW KEYS IN NORMAL MODE
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

"-----------------------------------
" CUSTOM COMMANDS (SHORTCUTS)

" Close other buffers and keep only the current one:
command! CloseOtherBuffers execute '%bdelete|edit #|normal `"'
nnoremap <silent> c, :CloseOtherBuffers<CR>| " Close other buffers and keep only the current one

"----------------------------------
" VIM EVENT HOOKS "

" Before saving a file, deletes any trailing whitespace at the end of each line.
" If no trailing whitespace is found no change occurs, and the e flag means no error is displayed.
autocmd BufWritePre * :%s/\s\+$//e

" After saving a file, display a notification:
autocmd BufWritePost * silent! !notify-send -a vim "File %:p saved."

"--------------------------------------------------
" ABBREVIATIONS
iabbrev apar ()<Left>| " abbreviation: matching parenthesis
iabbrev af ''<Left><Left>f<Right>| " abbreviation: python fstring

"--------------------------------------------------
" PLUGIN CONFIGURATIONS

""" VIM-MOVE
" Change vim-move modifier from A to C:
let g:move_key_modifier = 'C'

""" GUNDO
let g:gundo_prefer_python3 = 1
"Display the undo tree with <leader>u.
nnoremap <leader>t :GundoToggle<CR>| " Toggle undo tree preview

""" GUTENTAGS
"  https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/?utm_medium=android_app&utm_source=share
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]
" create a command on vim below to rebuild the Gutentags cache
command! -nargs=0 GutentagsClearCache call system('rm -fr ' . g:gutentags_cache_dir)
nmap <Leader>tc :GutentagsClearCache<CR>| " Clear Gutentags cache (the directory with all tags)
nmap <Leader>tu :GutentagsUpdate<CR>| " Update Gutentags
nmap <F8> :TagbarToggle<CR>| " Toggle ctags sidebar to easily navigate on code
"" Now we can turn our filetype functionality back on
filetype plugin indent on

""" VIM-BOOKMARKS
nmap <Leader>, <Plug>BookmarkToggle| " bookmarks: toggle
nmap <Leader>i <Plug>BookmarkAnnotate| "bookmarks: annotate
nmap <Leader>a <Plug>BookmarkShowAll| " bookmarks: show all
nmap <Leader>n <Plug>BookmarkNext| " bookmarks: next
nmap <Leader>p <Plug>BookmarkPrev| " bookmarks: previous
nmap <Leader>c <Plug>BookmarkClear| " bookmarks: clear
nmap <Leader>x <Plug>BookmarkClearAll| " bookmarks: clear all

map <C-t> <Plug>TaskList| " tasklist (TODO list)

""" FZF
let g:fzf_tags_command='ctags -f $HOME/.cache/vim/ctags/fzf_current_file_tag --tag-relative=yes --fields=+ailmnS'
let g:fzf_files_options = '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
nnoremap <C-f> :Files<Cr>| " fzf: select file by name
nnoremap <C-g> :Rg<Cr>| " fzf: select file by contents
nnoremap <C-b> :Buffers<Cr>| " fzf: select open buffers
nnoremap <C-O> :Commands<Cr>| " fzf: select commands
nnoremap <C-W> :Windows<Cr>| " fzf: select open windows
nnoremap <C-t> :Tags<Cr>| " fzf: search for tag (ctag) in file - search class, variable, etc...
" <Cr> | " fzf tip: open file on current window
" <C-x> | " fzf tip: open file on horizontal split
" <C-v> | " fzf tip: open file on vertical split
nnoremap <silent> <Leader>bd :bd!<Cr>| " fzf: buffer delete

""" SNIPMATE
" If I ever need to customize anything on snipmate, enable the line below
" let g:snipMate = {}

""" TAGBAR
map <F7> :TagbarToggle<CR>| " tagbar toggle
" let g:tagbar_autoclose = 1

""" VIM-PYENV
" Dont auto activate on start (to avoid the system pyenv error)
let g:pyenv#auto_activate=0

""" JEDI-VIM
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

""" LSC (LANGUAGE-SERVER)
set completeopt=menu,menuone,noinsert,noselect
autocmd CompleteDone * silent! pclose
" after opening a python file, check the file '/tmp/pyls.log' to see a complete 'workspace config'
" when you need to customize that.
let g:lsc_server_commands = {
 \  'python': {
 \    'command': 'pyls -vv --log-file /tmp/pyls.log',
 \    'workspace_config': {'pyls': {'plugins': {'rope_completion': {'enabled': v:true}}}},
 \  },
 \  'javascript': {
 \    'command': 'typescript-language-server --stdio',
 \    'log_level': -1,
 \    'suppress_stderr': v:true,
 \  }
 \}
let g:lsc_auto_map = {
 \  'defaults': v:true,
 \  'GoToDefinition': 'gd',
 \  'FindImplementations': 'gI',
 \  'FindReferences': 'gr',
 \  'Rename': 'gR',
 \  'ShowHover': 'K',
 \  'FindCodeActions': 'ga',
 \  'SignatureHelp': 'gm',
 \  'Completion': 'omnifunc',
 \}
let g:lsc_enable_autocomplete  = v:false
let g:lsc_enable_diagnostics   = v:false
let g:lsc_reference_highlights = v:false
let g:lsc_trace_level          = 'off'

""" DEOPLETE
let g:deoplete#enable_at_startup = 1

""" ALE
" More config options for python: https://github.com/dense-analysis/ale/blob/master/doc/ale-python.txt
" let g:ale_virtualenv_dir_names = [] " Disable auto-detection of virtualenvironments, so environment variable ${VIRTUAL_ENV} is always used
autocmd FileType python,sh let g:ale_linters = {'*': [], 'python': ['pylint']} " flake8, pycodestyle, bandit, mypy, etc...
autocmd FileType python,sh let g:ale_fixers = {'*': [], 'python': ['black', 'isort']}
" autocmd FileType python,sh let g:ale_python_pylint_options = '--rcfile ~/.pylintrc'
autocmd FileType python,sh let g:ale_python_pylint_options = '--rcfile .pylintrc'
autocmd FileType python,sh let g:ale_python_isort_options = '-m 3 -tc -y'
autocmd FileType python,sh let g:ale_python_black_options = '-S -t py37 -l 79  --exclude "/(\.git|\.venv|env|venv|build|dist)/"'
autocmd FileType python,sh let g:ale_fix_on_save = 1

"--------------------------------------------------
" OTHER

" a quickfix window opens with a 10-line height, even when the number of errors
" is 1 or 2. I think it's a waste of window space. So I wrote the following
" code in my vimrc. With it, a quickfix window height is automatically adjusted
" to fit its contents (maximum 5 lines).
" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
au FileType qf call AdjustWindowHeight(3, 5)
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
au FileType markdown nnoremap <leader>pp :call ConvertMarkdownToFormat('pdf')<cr>| " pandoc: convert markdown to pdf
au FileType markdown nnoremap <leader>ph :call ConvertMarkdownToFormat('html')<cr>| " pandoc: convert markdown to html

" Run git blame on current file
function! GitBlame()
  :silent execute '!git blame %:p'
  " Fix empty vim window by forcing a redraw
  :redraw!
endfu
nnoremap <leader>b :call GitBlame()<cr>| " git: git blame current file


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
nnoremap <silent> <C-z> :ZoomToggle<CR>| " toggle zoom on current window

" use the X clipboard for copy/paste
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

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

"--------------------------------------------------
" CHEATSHEET:

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
" w  | "  (movement)   next word
" b  | "  (movement)   beginning of current word / previous word
" ge | "  (movement)   end of the previous word
" e  | "  (movement)   end of current word / end of next word
" ^  | "  (movement)   first non-blank character of a line
" <C-e>| " (movement)   scroll viewport down, without moving cursor
" <C-y>| " (movement)   scroll viewport up, without moving cursor
" f [char]  | "  (movement)   go to specific char in line, ';' to go to the next occurrence of it
" t [char]  | "  (movement)   go to one character previous/before specific char in line, ';' to go to the next occurrence of it
" H  | " (movement) high on the viewport
" M  | " (movement) middle on the viewport
" L  | " (movement) low on the viewport
" zz  | "  (movement)   center the viewport (window) on the cursor, without moving the cursor.
" g; | " go to the previous place you were editing on the current file

"" snippets
" <C-l>| " select snippet
" <word><tab>| " expand snippet
" :Snippets| " snippets list powered by vim-fzf

"" language-server (lsc):
"(python-lsc) GoToDefinition | "  gd
"(python-lsc) FindImplementations | "  gI
"(python-lsc) FindReferences | "  gr
"(python-lsc) Rename | "  gR
"(python-lsc) ShowHover | "  K
"(python-lsc) FindCodeActions | "  ga
"(python-lsc) SignatureHelp | "  gm
"(python-ale) Show ALE information (useful for debugging) | " ALEInfo
"(python-ale) Run ALE Linter | " ALELint
"(python-ale) Run ALE Fixer suggestion (black) | " ALEFixSuggest
"(python-pyenv) Activate pyenv | " PyenvActivate <pyenv>
"(python-pyenv) Deactivate pyenv | " PyenvDeactivate

"" others

" :e| " reload current file
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
" shift+v  | "  select a whole line
" <control>, h  | "  move current line/selection to the left
" <control>, j  | "  move current line/selection down
" <control>, k  | "  move current line/selection up
" <control>, l  | "  move current line/selection to the right
" <control>, left or right | " cycle through open buffers
" :bd  | " remove a buffer from the buffer list and close it
" :w !sudo tee % | " save file as sudo when you forgot to do that
" :set et|retab | " replaces tab with 4 spaces
" gcc | " comment/uncomment selection

"" TODO: move the cheatsheet from vim.CHEATSHEET on the dot_files repo to here, to be browsable with rofi.
