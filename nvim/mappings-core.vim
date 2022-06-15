" CORE REMAPPPINGS - those that do not depend on any function, command or plugin

nnoremap <C-u> :undo<CR>| " (core) undo changes
nnoremap <Leader><Space> :w!<CR>| " (core) save file
nnoremap <C-o> :bufdo w! \| :q!<CR>| " (core) save all files and close/quit
nnoremap <C-x> :qa!<CR>| " (core) close/quit without saving
nnoremap <C-e> :e<CR>| " (core) reload file

nnoremap <CR> :nohlsearch<cr>| " de-highlights current highlighted search

vnoremap < <gv  " better indentation| " (VISUAL) deindent selection
vnoremap > >gv  " better indentation| " (VISUAL) indent selection

nnoremap <silent> <F6> :set list!<CR>| " (function-keys) toggle showing special chars (listchars)
nnoremap <silent> <F5> :set rnu!<CR>| " (function-keys) toggle relative line numbering

vnoremap <silent> * :call VisualSelection('f')<CR>| " search forwards current highlighted selection
vnoremap <silent> # :call VisualSelection('b')<CR>| " search backwards current highlighted selection

nnoremap <Backspace> :bw<Enter>| " Close buffer
nnoremap <leader>q :bp\|bw \#<Enter>| " Close buffer but keep split
nnoremap <leader><Backspace> <C-w>q<Enter>| " Close split but keep buffer

nnoremap <Leader>fcb :let @+=expand('%:t')<CR>| " copy current file/buffer name to clipboard
nnoremap <Leader>fcB :let @+=expand('%:p')<CR>| " copy current file/buffer full path name to clipboard

noremap <Up> <Nop> | " disable Up key in normal mode
noremap <Down> <Nop> | " disable Down key in normal mode
noremap <Left> <Nop> | " disable Left key in normal mode
noremap <Right> <Nop> | " disable Right key in normal mode

noremap <Leader>y "+y | " copy to system clipboard
noremap <Leader>p "+p | " paste from system clipboard

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

" CUSTOM NAVIGATION
" Keep the cursor in place when you join lines with J. That will also drop a mark before the operation to which you return afterwards:
nnoremap J mzJ`z
" Remap navigation commands to center view on cursor using zz
nnoremap j jzz
nnoremap k kzz
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap # #zz
nnoremap * *zz

nnoremap <Leader>m :Marks<CR>| " (marks) show all
nnoremap <Leader>mda :delmarks!<CR>| " (marks) delete all

nnoremap <Leader>wj <c-w>j| " (windows) move to down window
nnoremap <Leader>wk <c-w>k| " (windows) move to up window
nnoremap <Leader>wh <c-w>h| " (windows) move to left window
nnoremap <Leader>wl <c-w>l| " (windows) move to right window
nnoremap <Leader>wJ <c-w>J| " (windows) shift to down window
nnoremap <Leader>wK <c-w>K| " (windows) shift to up window
nnoremap <Leader>wH <c-w>H| " (windows) shift to left window
nnoremap <Leader>wL <c-w>L| " (windows) shift to right window
nnoremap <Leader>wr <c-w>r| " (windows) shift rotate split window
noremap <Leader>ws  <c-w>t<c-w>K| " (windows) change split orientation to horizontal
noremap <Leader>wv  <c-w>t<c-w>H| " (windows) change split orientation to vertical
nnoremap <Leader>ww <C-w>w| " (windows)  toggle between windows
nnoremap <Leader>wV :vnew<CR>| " (windows) new vertical window split
nnoremap <Leader>wS :new<CR>| " (windows) new horizontal window split

nnoremap <Leader>llt :set spell!<CR>| " (spellcheck) toggle on/off
nnoremap <Leader>lle :set spelllang=en<CR>| " (spellcheck) set language to english
nnoremap <Leader>llp :set spelllang=pt_br<CR>| " (spellcheck) set language to portuguese brazil

