" PLUGINS REMAPPPINGS - those that do depend on 3rd party installed plugins
"

" telescope

nnoremap <C-f> <cmd>Telescope find_files<cr>| " (telescope) open file
nnoremap <C-F> <cmd>Telescope git_files<cr>| " (telescope) open file, respecting .gitignore
nnoremap <C-g> <cmd>Telescope live_grep<cr>| " (telescope) search for string on current directory
nnoremap <leader>* <cmd>Telescope grep_string<cr>| " (telescope) search for string under cursor on current directory
nnoremap <C-b> <cmd>Telescope buffers<cr>| " (telescope) open buffer
nnoremap <leader>m <cmd>Telescope marks<cr>| " (telescope) browse marks
nnoremap <leader>r <cmd>Telescope registers<cr>| " (telescope) browse registers
nnoremap <leader>tq <cmd>Telescope quickfix<cr>| " (telescope) browse quickfix
nnoremap <leader>tl <cmd>Telescope loclist<cr>| " (telescope) browse location-list
nnoremap <leader>tt <cmd>Telescope help_tags<cr>| " (telescope) tags
nnoremap <leader>ta <cmd>Telescope builtin<cr>| " (telescope) all commands
nnoremap <leader>tm <cmd>Telescope man_pages<cr>| " (telescope) open man page
nnoremap <leader>tc <cmd>Telescope colorscheme<cr>| " (telescope) browser color schemes

nnoremap <F10> :SearchQuickNotes<cr>|" (telescope)(functions) search quick note
nnoremap <F11> :SearchZettel<cr>|" (telescope)(functions) search zettelkasten card
nnoremap <F12> :SearchTaskCard<cr>|" (telescope)(functions) search task card
nnoremap <leader>fp :OpenPersonalDoc<cr>|" (telescope)(functions) open personal doc
nnoremap <leader>fw :OpenWorkDoc<cr>|" (telescope)(functions) open work doc

