" PLUGINS REMAPPPINGS - those that do depend on 3rd party installed plugins
"

" -- telescope

nnoremap <leader>tb :Telescope file_browser<cr>| " (telescope) browse files
nnoremap <C-f> :Telescope find_files<cr>| " (telescope) fuzzy open file
nnoremap <C-g> :Telescope live_grep<cr>| " (telescope) search for string on current directory
nnoremap <leader>* :Telescope grep_string<cr>| " (telescope) search for string under cursor on current directory
nnoremap <C-b> :Telescope buffers<cr>| " (telescope) open buffer
nnoremap <leader>m :Telescope marks<cr>| " (telescope) browse marks
nnoremap <leader>r :Telescope registers<cr>| " (telescope) browse registers
nnoremap <leader>tq :Telescope quickfix<cr>| " (telescope) browse quickfix
nnoremap <leader>tl :Telescope loclist<cr>| " (telescope) browse location-list
nnoremap <leader>tt :Telescope help_tags<cr>| " (telescope) tags
nnoremap <leader>ta :Telescope builtin<cr>| " (telescope) all commands
nnoremap <leader>tm :Telescope man_pages<cr>| " (telescope) open man page
nnoremap <leader>tc :Telescope colorscheme<cr>| " (telescope) browser color schemes

nnoremap <F10> :SearchQuickNotes<cr>|" (telescope)(functions) search quick note
nnoremap <F11> :SearchZettel<cr>|" (telescope)(functions) search zettelkasten card
nnoremap <F12> :SearchTaskCard<cr>|" (telescope)(functions) search task card
nnoremap <leader>fp :OpenPersonalDoc<cr>|" (telescope)(functions) open personal doc
nnoremap <leader>fw :OpenWorkDoc<cr>|" (telescope)(functions) open work doc


" -- leaderf
inoremap <c-s><c-n> <c-\><c-o>:Leaderf snippet --popup<CR> | " (INSERT) (leaderf) insert code snippet on cursor
" nnoremap <Leader>J :Leaderf jumps --popup<CR> | " (jumps) (leaderf) interactive jump selection
" nnoremap <Leader>ch :Leaderf cmdHistory --popup<CR> | " (leaderf) search on commands history
" nnoremap <Leader>sh :Leaderf searchHistory --popup<CR> | " (leaderf) redo a search from search history
" nnoremap <Leader>c :Leaderf command --popup<CR> | " (leaderf) Run command from vim command "palette"



" -- surround

" csw` | " (surround) surround current word with ` - you can use [({ instead of `
" ds` | " (surround) delete ` surrounding current word - you can use [({ instead of `
" S` (on visual selection) | " (surround) surround current visual selection with ` - you can use [({ instead of ` (S is the 'current text selection' vim object)
" ys2w` | " (surround) surround next 2 words with ` - you can use [({ instead of `
" ystA` | " (surround) surround until letter A with ` - you can use [({ instead of `



