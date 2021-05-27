" CORE REMAPPPINGS - those that do not depend on any function, command or plugin

nnoremap <C-u> :undo<CR>| " (core) undo changes
nnoremap <Leader><Space> :w!<CR>| " (core) save file
nnoremap <Leader><Space>w :windo w! \| :q!<CR>| " (core) save all files and quit
nnoremap <Leader><Space>q :q!<CR>| " (core) quit
nnoremap <C-e> :e<CR>| " (core) reload file

nnoremap <CR> :nohlsearch<cr>| " de-highlights current highlighted search

vnoremap < <gv  " better indentation| " (VISUAL) deindent selection
vnoremap > >gv  " better indentation| " (VISUAL) indent selection

nnoremap <silent> <F6> :set list!<CR>| " function key: toggle showing special chars (listchars)

vnoremap <silent> * :call VisualSelection('f')<CR>| " search forwards current highlighted selection
vnoremap <silent> # :call VisualSelection('b')<CR>| " search backwards current highlighted selection

nnoremap <Backspace> :bw<Enter>| " Close buffer
nnoremap <leader>q :bp\|bw \#<Enter>| " Close buffer but keep split
nnoremap <leader><Backspace> <C-w>q<Enter>| " Close split but keep buffer

nnoremap <Leader>fcb :let @+=expand('%:p')<CR>| " copy current file/buffer name to clipboard

noremap <Up> <Nop> | " disable Up key in normal mode
noremap <Down> <Nop> | " disable Down key in normal mode
noremap <Left> <Nop> | " disable Left key in normal mode
noremap <Right> <Nop> | " disable Right key in normal mode

noremap <Leader>y "+y | " copy to system clipboard
noremap <Leader>p "+p | " paste from system clipboard

" reference: https://www.reddit.com/r/vim/comments/i50pce/how_to_show_commit_that_introduced_current_line
map <silent><Leader>gc :call setbufvar(winbufnr(popup_atcursor(systemlist("cd " . shellescape(fnamemodify(resolve(expand('%:p')), ":h")) . " && git log --no-merges -n 1 -L " . shellescape(line("v") . "," . line(".") . ":" .  resolve(expand("%:p")))), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")<CR> | " (git) show commit that introduced current line in vim

nnoremap <Leader>hc :set cuc!<CR> | " toggle highlight current column identation
nnoremap <Leader>hl :set cursorline!<CR> | " toggle highlight current line

nnoremap <c-j> :m .+1<CR>== | "(movement) move current line or selection down
nnoremap <c-k> :m .-2<CR>== | "(movement) move current line or selection up

nnoremap <leader>nt :tabnew<CR> | " (tabs) new
nnoremap <leader>ct :tabclose<CR> | " (tabs) close
nnoremap <C-right> :tabnext<CR> | " (NORMAL) (tabs) next
nnoremap <C-left> :tabprevious<CR> | " (NORMAL) (tabs) previous
inoremap <C-right> <Esc>:tabnext<CR> | " (INSERT) (tabs) next
inoremap <C-left> <Esc>:tabprevious<CR> | " (INSERT) (tabs) previous

nnoremap <Leader>m :Marks<CR>| " (marks) show all
nnoremap <Leader>mda :delmarks!<CR>| " (marks) delete all
