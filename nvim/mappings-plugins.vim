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
nnoremap <leader>t :Telescope builtin<cr>| " (telescope) all commands
nnoremap <leader>tr :Telescope registers<cr>| " (telescope) browse registers
nnoremap <leader>tq :Telescope quickfix<cr>| " (telescope) browse quickfix
nnoremap <leader>tl :Telescope loclist<cr>| " (telescope) browse location-list
nnoremap <leader>tt :Telescope help_tags<cr>| " (telescope) tags
nnoremap <leader>tm :Telescope man_pages<cr>| " (telescope) open man page
nnoremap <leader>tc :Telescope colorscheme<cr>| " (telescope) browser color schemes
nnoremap <silent>gr :lua require'telescope.builtin'.lsp_references{}<CR>| "(telescope) search over variable references from your LSP


" -- vim-vsnip
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)


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
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>| " (lsp) go to previous diagnostic
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>| " (lsp) go to next diagnostic
" lspsaga
nnoremap <silent> K :Lspsaga hover_doc<CR>|" (lsp-saga) documentation hover
nnoremap <silent> gs :Lspsaga signature_help<CR>|" (lsp-saga) (NORMAL mode) signature help
inoremap <silent> <C-k> :Lspsaga signature_help<CR>|" (lsp-saga) (INSERT mode) signature help
nnoremap <silent> gh :Lspsaga lsp_finder<CR>|" (lsp-sage) finder
nnoremap <silent><leader>ca :Lspsaga code_action<CR>|" (lsp-saga) code action
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>|" (lsp-saga) code action

" floatterm special terminals, to trigger special commands
nnoremap <leader>u :FloatermNew lazygit<cr>| " (floaterm) lazygit ui
nnoremap <leader>du :FloatermNew ncdu<cr>| " (floaterm) directory size
nnoremap <leader>py :FloatermNew python<cr>| " (floaterm) default python interpreter
nnoremap <leader>py2 :FloatermNew python2<cr>| " (floaterm) default python2 interpreter
nnoremap <leader>py3 :FloatermNew python3<cr>| " (floaterm) default python3 interpreter

" nvim-tree (a project directory tree)
nnoremap <F3> :NvimTreeToggle<CR>| " (function-keys) toggle project directory tree


