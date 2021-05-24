" PLUGINS REMAPPPINGS - those that do depend on 3rd party installed plugins
"

" telescope

nnoremap <C-f> :Telescope file_browser<cr>| " (telescope) browse files
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

" snipmate

" If I ever need to customize anything on snipmate, enable the line below
let g:snipMate = { 'snippet_version' : 1 }
