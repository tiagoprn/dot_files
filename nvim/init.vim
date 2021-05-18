" --- MAIN SETTINGS
"
" Rebind <Leader> key
map <SPACE> <leader>

syntax on

set title
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*~

set relativenumber  " Changing the ruler position
set number  " show line numbers
" set winwidth=80  "minimum window width

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

augroup textconf
    autocmd!
    " set virtualedit=all  " BREAKTHROUGH CHANGE: allows to move the cursor past the last character. If you insert a new character there, it is automatically padded with spaces. Useful for e.g. tables
    " autocmd FileType markdown,text InsertLeave * normal gwap<CR> " formats the current paragraph when leaving insert mode
    " do not use textwidth with soft wrap, it has no effect
    autocmd FileType markdown,text,vim set linebreak  " soft wrap: wrap the text when it hits the screen edge
augroup END

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


" --- REMAPPINGS
"
nnoremap <C-u> :undo<CR>| " undo changes
nnoremap <Leader><Space> :w!<CR>| " (core) save file and redraw screen to cleanup from glitches
nnoremap <Leader><Space>w :windo w! \| :q!<CR>| " (core) save all files and quit
nnoremap <Leader><Space>q :q!<CR>| " (core) quit
nnoremap <C-e> :e<CR>| " (core) reload file

nnoremap <CR> :nohlsearch<cr>| " de-highlights current highlighted search

" When on visual selection mode (v), then
" easier moving of code blocks
" Try to go into visual selection mode (v), then
" select several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation| " (VISUAL) deindent selection
vnoremap > >gv  " better indentation| " (VISUAL) indent selection

nnoremap <silent> <F6> :set list!<CR>| " function key: toggle showing special chars (listchars)

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>| " search forwards current highlighted selection
vnoremap <silent> # :call VisualSelection('b')<CR>| " search backwards current highlighted selection

nnoremap <Backspace> :bw<Enter>| " Close buffer
nnoremap <leader>q :bp\|bw \#<Enter>| " Close buffer but keep split
nnoremap <leader><Backspace> <C-w>q<Enter>| " Close split but keep buffer

" Copy current buffer name to clipboard
nnoremap <Leader>fcb :let @+=expand('%:p')<CR>| " copy current file name to clipboard

" DISABLE ARROW KEYS IN NORMAL MODE
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>


" --- CUSTOM COMMANDS
"
" Copy current buffer name to clipboard
nnoremap <Leader>fcb :let @+=expand('%:p')<CR>| " copy current file name to clipboard

" DISABLE ARROW KEYS IN NORMAL MODE
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

command! Regclear for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor | " (registers) cleans all vim registers

command! GetHLG echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') | " show the highlight group of the token under your cursor, so that you could e.g. customize it

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

"Sample lua function
command! WelcomeToLua lua require'sample'.welcomeToLua()
nnoremap <leader>wel :WelcomeToLua<CR>| " Call sample lua function

" --- EVENT HOOKS
"
augroup eventhooks
	autocmd!
	" Before saving a file, deletes any trailing whitespace at the end of each line.
	" If no trailing whitespace is found no change occurs, and the e flag means no error is displayed.
	autocmd BufWritePre * :%s/\s\+$//e

	" When opening a new buffer, if it has no filetype defaults to text
	autocmd BufEnter * if &filetype == "" | setlocal filetype=text | endif

	" Return to last edit position when opening files (You want this!)
	autocmd BufReadPost *
		    \ if line("'\"") > 0 && line("'\"") <= line("$") |
		    \   exe "normal! g`\"" |
		    \ endif

	" Expands on what vim considers as a markdown filetype
	autocmd BufNewFile,BufFilePre,BufRead *.md,*.markdown,*.mmd set filetype=markdown
augroup END


" --- ABBREVIATIONS
"
iabbrev apar ()<Left>| " abbreviation: matching parenthesis
iabbrev af ''<Left><Left>f<Right>| " abbreviation: python fstring
