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
nnoremap <leader>t :Telescope aerial<cr>| " (telescope) code navigation through classes, methods and functions
nnoremap <leader>ta :Telescope builtin<cr>| " (telescope) all commands
nnoremap <leader>tr :Telescope registers<cr>| " (telescope) browse registers
nnoremap <leader>tq :Telescope quickfix<cr>| " (telescope) browse quickfix
nnoremap <leader>tl :Telescope loclist<cr>| " (telescope) browse location-list
nnoremap <leader>tt :Telescope help_tags<cr>| " (telescope) tags
nnoremap <leader>tm :Telescope man_pages<cr>| " (telescope) open man page
nnoremap <leader>tc :Telescope colorscheme<cr>| " (telescope) browser color schemes
nnoremap <silent>gr :lua require'telescope.builtin'.lsp_references{}<CR>| "(telescope) search over variable references from your LSP
nnoremap <leader>tn :Telescope notify<cr>| " (telescope) show notifications history

" -- surround
" csw` | " (surround) surround current word with ` - you can use [({ instead of `
" ds` | " (surround) delete ` surrounding current word - you can use [({ instead of `
" S` (on visual selection) | " (surround) surround current visual selection with ` - you can use [({ instead of ` (S is the 'current text selection' vim object)
" ys2w` | " (surround) surround next 2 words with ` - you can use [({ instead of `
" ystA` | " (surround) surround until letter A with ` - you can use [({ instead of `


" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>| " (lsp) go to definition
nnoremap <silent> <leader>le <cmd>lua vim.lsp.buf.declaration()<CR>| " (lsp) go to declaration
nnoremap <silent> <leader>lr <cmd>lua vim.lsp.buf.references()<CR>| " (lsp) show references
nnoremap <silent> <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>| " (lsp) go to implementation
nnoremap <silent> <leader>ln <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>| " (lsp) go to previous diagnostic
nnoremap <silent> <leader>lp <cmd>lua vim.lsp.diagnostic.goto_next()<CR>| " (lsp) go to next diagnostic
nnoremap <silent> <leader>lt <cmd>lua vim.lsp.buf.format(nil,1200)<CR>| " (lsp) format file (e.g. isort, black) with null-ls
nnoremap <silent> <leader>lo :LspInfo <CR>| " (lsp) Show Info
nnoremap <silent> <leader>loo :NullLsInfo <CR>| " (lsp) Show NullLs Info
" lspsaga
nnoremap <silent> <leader>lh :Lspsaga hover_doc<CR>| " (lsp-saga) documentation hover
nnoremap <silent> <leader>ls :Lspsaga signature_help<CR>| " (lsp-saga) (NORMAL mode) signature help
nnoremap <silent> <leader>lf :Lspsaga lsp_finder<CR>| " (lsp-sage) finder
nnoremap <silent> <leader>la :Lspsaga code_action<CR>| " (lsp-saga) code action
vnoremap <silent> <leader>la :<C-U>Lspsaga range_code_action<CR>| " (lsp-saga) code action
inoremap <silent> <C-s> :Lspsaga signature_help<CR>| " (lsp-saga) (INSERT mode) signature help

" toggleterm special terminals, to trigger special commands
nnoremap <leader>u <cmd>:lua _LAZYGIT_TOGGLE()<CR>| " (toggleterm) lazygit ui
nnoremap <leader>tt :ToggleTerm direction=horizontal size=10<CR>| " (toggleterm) blank terminal
nnoremap <leader>tty :ToggleTermSendCurrentLine<CR>| " (toggleterm) copy current line to terminal
vnoremap <leader>ttv :ToggleTermSendVisualSelection<CR>| " (toggleterm) copy visual selection to terminal

" nvim-tree (a project directory tree)
nnoremap <F3> :NvimTreeToggle<CR>| " (function-keys) toggle project directory tree

" hop
nnoremap <silent> <leader>hw <cmd>lua require'hop'.hint_words()<CR>| " (movement) hop - go to word
nnoremap <silent> <leader>hl <cmd>lua require'hop'.hint_lines()<CR>| " (movement) hop - go to line
vnoremap <silent> <leader>hw <cmd>lua require'hop'.hint_words()<CR>| " (VISUAL) (movement) hop - go to word
vnoremap <silent> <leader>hl <cmd>lua require'hop'.hint_lines()<CR>| " (VISUAL) (movement) hop - go to line

" snippy
inoremap <silent> <c-s> <cmd>lua require'snippy'.complete()<CR>| " (INSERT) show all available snippets for current filetype

" aerial code navigation
nnoremap <silent> t :AerialToggle<CR>| " (lsp) code navigation through classes and methods

" session manager
nnoremap <silent> <leader>ss :SessionManager save_current_session<CR>| " (sessions) save current session
nnoremap <silent> <leader>sl :SessionManager load_session<CR>| " (sessions) load session
nnoremap <silent> <leader>sd :SessionManager delete_session<CR>| "  (sessions) delete session

" gitsigns
nnoremap <silent> <leader>gb :Gitsigns blame_line<CR>| " (gitsigns) blame line
nnoremap <silent> <leader>gj :Gitsigns next_hunk<CR>| "  (gitsigns) go to next changed hunk
nnoremap <silent> <leader>gk :Gitsigns prev_hunk<CR>| "  (gitsigns) go to next changed hunk
nnoremap <silent> <leader>gp :Gitsigns preview_hunk<CR>| "  (gitsigns) preview hunk

" navigator
nnoremap <silent> <A-J> :NavigatorDown<CR>| " (navigator) move to down split/tmux pane
nnoremap <silent> <A-K> :NavigatorUp<CR>| " (navigator) move to up split/tmux pane
nnoremap <silent> <A-H> :NavigatorLeft<CR>| " (navigator) move to left split/tmux pane
nnoremap <silent> <A-L> :NavigatorRight<CR>| " (navigator) move to right split/tmux pane
nnoremap <silent> <A-P> :NavigatorPrevious<CR>| " (navigator) move to previous split/tmux pane
