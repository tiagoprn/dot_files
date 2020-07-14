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
colorscheme fahrenheit

" font (commented to use the same font as set on the terminal)
" set anti gfn=JetBrains\ Mono\ 11
" set guifont=Fira\ Code\ 11
" set guifont=JetBrains\ Mono\ 11

set title
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*~

" Changing the ruler position
set relativenumber

" LINES CONFIGURATION
set number  " show line numbers
set winwidth=80  "minimum window width
set textwidth=99   " maximum line length
set formatoptions+=t  " automatically wrap text when typing
" set formatoptions-=t   " don't automatically wrap text when typing
set formatoptions-=l  " Force line wrapping

" TABs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Below is because of:
" https://stackoverflow.com/questions/42377945/vim-adding-cursorshape-support-over-tmux-ssh
set t_SI=[6\ q
set t_SR=[4\ q
set t_EI=[2\ q

" the File, Open dialog defaults to the current file's directory.
set browsedir=buffer

" automatically change window's cwd to file's dir
set autochdir

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

" Remember info about open buffers on close
set viminfo^=%

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
nnoremap <C-r> :redraw!<CR>| " redraw screen to cleanup from glitches
nnoremap <CR> :nohlsearch<cr>| " de-highlights current highlighted search

nnoremap j gj| " move vertically down by visual line
nnoremap k gk| " move vertically up by visual line

map <Leader>all <esc>gg0vG$<CR>| " select all text in the file

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

nnoremap <silent> <F6> :set list!<CR>| " function key: toggle showing special chars (listchars)
" Overriding color of special chars
" highlight SpecialKey ctermfg=red guifg=red
" Overriding color of the line numbers
highlight LineNr ctermbg=black ctermfg=green

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>| " search forwards current highlighted selection
vnoremap <silent> # :call VisualSelection('b')<CR>| " search backwards current highlighted selection

" Auto setup vim make command to run lint
let project_path = system("git rev-parse --show-toplevel | tr -d '\\n'")
let &makeprg = "cd " . project_path . " && make lint"
nnoremap <expr> <F9> '<Esc>:cd ' . project_path . ' \| make<CR>'| " function key: Run linter
nnoremap <Leader>w <C-w>w| " toggle between windows

nnoremap <Backspace> :bw<Enter>| " Close buffer
nnoremap <leader>q :bp\|bw \#<Enter>| " Close buffer but keep split
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

nnoremap <Leader>m :Marks<CR>| " show all marks

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
nnoremap <Leader>M :call MarkDelete()<CR>| " delete mark

nnoremap <leader>fp :call fzf#run(fzf#vim#with_preview({'options': '--reverse --prompt "Select file from my PERSONAL notes directory: "', 'down': 20, 'dir': '/storage/docs/notes/personal', 'sink': 'e' }))<CR>| " open file from my PERSONAL notes directory
nnoremap <leader>fw :call fzf#run(fzf#vim#with_preview({'options': '--reverse --prompt "Select file from my WORK notes directory: "', 'down': 20, 'dir': '/storage/docs/notes/work', 'sink': 'e' }))<CR>| " open file from my WORK notes directory

command! -bang -nargs=* Zettel call fzf#vim#grep( 'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '/storage/docs/notes/zettelkasten/cards'}), <bang>0)
nnoremap <leader>fz :Zettel()<CR>| " open zettelkasten notes searching by word

command! -bang -nargs=* QuickNotes call fzf#vim#grep( 'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '/storage/docs/notes/quick'}), <bang>0)
nnoremap <leader>fn :QuickNotes()<CR>| " open quicknotes searching by word

function! ReloadVimConfig()
    execute 'w!'
    execute 'source ~/.vimrc'
    execute 'silent !notify-send --urgency=critical "Vim configuration successfully reloaded."'
endfunction
nnoremap <leader>rl :call ReloadVimConfig()<CR>| " reload vim configuration (.vimrc)

command! Regclear for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor | " (registers) cleans all vim registers

command! GetHLG echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') | " show the highlight group of the token under your cursor, so that you could e.g. customize it

nnoremap <silent> <F3> :Goyo<CR>| " function key: toggle goyo distraction-free mode
" >>>

" Vim event hooks <<<

" Before saving a file, deletes any trailing whitespace at the end of each line.
" If no trailing whitespace is found no change occurs, and the e flag means no error is displayed.
autocmd BufWritePre * :%s/\s\+$//e

" After saving a file, display a notification:
autocmd BufWritePost * silent! !notify-send -a vim "File %:p saved."

" When opening a new buffer, if it has no filetype defaults to text
autocmd BufEnter * if &filetype == "" | setlocal filetype=text | endif

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

" Expands on what vim considers as a markdown filetype
autocmd BufNewFile,BufFilePre,BufRead *.md,*.markdown,*.mmd set filetype=markdown

" >>>

" Abbreviations <<<
iabbrev apar ()<Left>| " abbreviation: matching parenthesis
iabbrev af ''<Left><Left>f<Right>| " abbreviation: python fstring
" >>>

" PLUGIN CONFIGURATIONS <<<

" GUTENTAGS <<<
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

set tags=~/.cache/vim/ctags

map <C-t> <Plug>TaskList| " tasklist (TODO list)
" >>>

" FZF <<<
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
nnoremap <silent> <Leader>bd :bd!<Cr>| " fzf: buffer delete - deletes the buffer from the session, but keeps marks and the jump list
nnoremap <silent> <Leader>bw :bw!<Cr>| " fzf: buffer wipe - deletes all traces from the buffer on the session (marks, jump list, etc...)
" >>>

" SNIPMATE <<<
" If I ever need to customize anything on snipmate, enable the line below
" let g:snipMate = {}
" >>>

" VISTA <<<
nmap <F7> :Vista!!<CR>| " function key: Toggle ctags sidebar to easily navigate on code
let g:vista_default_executive = 'ctags'
let g:vista_executive_for = {
    \ 'python': 'ale',
    \ 'markdown': 'toc',
    \ }
let g:vista_highlight_whole_line = 1

autocmd FileType vista,vista_kind nnoremap <buffer> <silent> <F8> :<c-u>call vista#finder#fzf#Run()<CR>| " function key: vista search for symbol (function, variable, import)
autocmd FileType python nnoremap <buffer> <silent> <F8> :Vista finder ale<CR>| " function key: vista search for symbol (function, variable, import)
autocmd FileType markdown nnoremap <buffer> <silent> <F8> :Vista finder<CR>| " function key: vista search for symbol (function, variable, import)
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
" autocmd FileType python let g:ale_python_pylint_options = '--rcfile ~/.pylintrc'
autocmd FileType python let g:ale_python_pylint_options = '--rcfile .pylintrc'
autocmd FileType python let g:ale_python_isort_options = '-m 3 -tc -y'
autocmd FileType python let g:ale_python_black_options = '-S -t py37 -l 79  --exclude "/(\.git|\.venv|env|venv|build|dist)/"'
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
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
" >>>

" >>>

" Global autocmds and miscelaneus <<<
autocmd VimResized * wincmd =  " resize vim splits proportionally when the window that contains vim is resized

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" sets a gray margin on column 80
"" set colorcolumn=80
" past column 80, the background will be a different color
"" let &colorcolumn=join(range(120,9999),",")

au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79
au FileType markdown set textwidth=79

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
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

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
" w  | "  (movement)   next word
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
" ctrl+h | " move current character left
" ctrl+l | " move current character right

"" snippets
" <C-l>| " select snippet
" <word><tab>| " expand snippet
" :Snippets| " snippets list powered by vim-fzf

"" python specific
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
" :w !sudo tee % | " save file as sudo when you forgot to do that
" :set et|retab | " replaces tab with 4 spaces
" gcc | " comment/uncomment selection
" zR | " open all folds
" zM | " close all folds
" zo | " open current fold
" zc | " close current fold
" za | " toggle current fold
" zd | " delete current fold
" "+yy | " (registers) copy current line to system clipboard (change + for * to primary 'mouse " selection' clipboard)
" "+veey | " (registers) copy next 2 words to system clipboard
" "+p | " (registers) paste system clipboard contents
" "ayy | " (registers) copy current line to register a
" "Ayy | " (registers) append current line to register a (use a capital letter to append to a register)
" "ap | " (registers) paste register a contents
" :reg | " (registers) see all registers' contents
" :verbose map | " show all defined mappings in vim - and where the mappings are defined
" :map | " show all defined mappings in vim

" TODO: move the cheatsheet from vim.CHEATSHEET on the dot_files repo to here, to be browsable with rofi.
" >>>

