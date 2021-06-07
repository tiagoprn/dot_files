" PLUGINS REMAPPPINGS - those that do depend on 3rd party installed plugins
"

" -- telescope
nnoremap <leader>tb :Telescope file_browser<cr>| " (telescope) browse files
nnoremap <C-f> :Telescope find_files find_command=fd,-H,-E,.git prompt_prefix=fd:  <cr>| " (telescope) fuzzy open file (fd)
nnoremap <leader>tf :Telescope find_files<cr>| " (telescope) fuzzy open file (built-in)
nnoremap <C-g> :Telescope live_grep<cr>| " (telescope) search for string on current directory (built-in)
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
nnoremap <silent>gr :lua require'telescope.builtin'.lsp_references{}<CR>| "(telescope) search over variable references from your LSP


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


" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>| " (lsp) go to definition
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>| " (lsp) go to declaration
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>| " (lsp) show references
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>| " (lsp) go to implementation
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>| " (lsp) help hover
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>| " (lsp) signature
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>| " (lsp) go to previous diagnostic
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>| " (lsp) go to next diagnostic

