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
nnoremap <leader>tn :Telescope aerial<cr>| " (telescope) code navigation through classes, methods and functions
nnoremap <leader>ta :Telescope builtin<cr>| " (telescope) all commands
nnoremap <leader>tr :Telescope registers<cr>| " (telescope) browse registers
nnoremap <leader>tq :Telescope quickfix<cr>| " (telescope) browse quickfix
nnoremap <leader>tl :Telescope loclist<cr>| " (telescope) browse location-list
nnoremap <leader>tt :Telescope help_tags<cr>| " (telescope) tags
nnoremap <leader>tm :Telescope man_pages<cr>| " (telescope) open man page
nnoremap <leader>tc :Telescope colorscheme<cr>| " (telescope) browser color schemes
nnoremap <leader>mk :Telescope make<cr>| " (telescope) run Makefile command
nnoremap <silent>gr :lua require'telescope.builtin'.lsp_references{}<CR>| "(telescope) search over variable references from your LSP
nnoremap <silent> <F9> :Telescope notify<cr>| " (telescope)(function-keys) show notifications history (vim-notify)



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


" harpoon
nnoremap <silent> <C-h> <cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>| " (navigation - harpoon) quick menu
nnoremap <silent> <leader>ha <cmd>lua require("harpoon.mark").add_file()<CR>| " (navigation - harpoon) add current file
nnoremap <silent> <leader>h1 <cmd>lua require("harpoon.ui").nav_file(1)<CR>| " (navigation - harpoon) go to file 1
nnoremap <silent> <leader>h2 <cmd>lua require("harpoon.ui").nav_file(2)<CR>| " (navigation - harpoon) go to file 2
nnoremap <silent> <leader>h3 <cmd>lua require("harpoon.ui").nav_file(3)<CR>| " (navigation - harpoon) go to file 3
nnoremap <silent> <leader>h4 <cmd>lua require("harpoon.ui").nav_file(4)<CR>| " (navigation - harpoon) go to file 4
nnoremap <silent> <leader>h5 <cmd>lua require("harpoon.ui").nav_file(5)<CR>| " (navigation - harpoon) go to file 5
nnoremap <silent> <leader>h6 <cmd>lua require("harpoon.ui").nav_file(6)<CR>| " (navigation - harpoon) go to file 6
nnoremap <silent> <leader>h7 <cmd>lua require("harpoon.ui").nav_file(7)<CR>| " (navigation - harpoon) go to file 7
nnoremap <silent> <leader>h8 <cmd>lua require("harpoon.ui").nav_file(8)<CR>| " (navigation - harpoon) go to file 8
nnoremap <silent> <leader>h9 <cmd>lua require("harpoon.ui").nav_file(9)<CR>| " (navigation - harpoon) go to file 9
nnoremap <silent> <leader>hn <cmd>lua require("harpoon.ui").nav_next()<CR>| " (navigation - harpoon) go to next file on the list
nnoremap <silent> <leader>hp <cmd>lua require("harpoon.ui").nav_prev()<CR>| " (navigation - harpoon) go to previous file on the list
nnoremap <silent> <leader>ht <cmd>lua require("harpoon.tmux").gotoTerminal("{down-of}")<CR>| " (navigation - harpoon) go to tmux pane below
nnoremap <silent> <leader>hc <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", vim.fn.input("Enter the command: "))<CR>| " (navigation - harpoon) run command on tmux pane below
nnoremap <silent> <leader>hm :Easypick make<CR>| " (navigation - harpoon) run make command from easypick select on tmux pane below
nnoremap <silent> <leader>hc1 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 1)<CR>| " (navigation - harpoon) run project command 1 on tmux pane below
nnoremap <silent> <leader>hc2 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 2)<CR>| " (navigation - harpoon) run project command 2 on tmux pane below
nnoremap <silent> <leader>hc3 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 3)<CR>| " (navigation - harpoon) run project command 3 on tmux pane below
nnoremap <silent> <leader>hc4 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 4)<CR>| " (navigation - harpoon) run project command 4 on tmux pane below
nnoremap <silent> <leader>hc5 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 5)<CR>| " (navigation - harpoon) run project command 5 on tmux pane below
nnoremap <silent> <leader>hc6 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 6)<CR>| " (navigation - harpoon) run project command 6 on tmux pane below
nnoremap <silent> <leader>hc7 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 7)<CR>| " (navigation - harpoon) run project command 7 on tmux pane below
nnoremap <silent> <leader>hc8 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 8)<CR>| " (navigation - harpoon) run project command 8 on tmux pane below
nnoremap <silent> <leader>hc9 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 9)<CR>| " (navigation - harpoon) run project command 9 on tmux pane below
" nnoremap <silent> <leader>hz <cmd>lua require("harpoon.tmux").gotoTerminal("{end}")<CR>| " (navigation - harpoon) go to last tmux numbered window

" trouble
nnoremap <leader>xx <cmd>TroubleToggle<CR>| " (trouble) toggle default - document diagnostics
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<CR>| " (trouble) toggle workspace diagostics
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<CR>| " (trouble) toggle document diagnostics
nnoremap <leader>xq <cmd>TroubleToggle quickfix<CR> :cclose<CR>| " (trouble) toggle quickfix
nnoremap <leader>xl <cmd>TroubleToggle loclist<CR> :lclose<CR>| " (trouble) toggle loclist (location list)
nnoremap <leader>xr <cmd>TroubleToggle lsp_references<CR>| " (trouble) toggle lsp references

" zen-mode
nnoremap <C-z> :ZenCode<CR>| " (zen) toggle current buffer full screen
nnoremap <leader>zz :ZenWrite<CR>| " (zen) toggle current buffer full screen - distraction free mode

" toggleterm special terminals, to trigger special commands
nnoremap <leader>u :!tmux select-window -t git<CR>| " (tmux) go to lazygit tmux window
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
nnoremap <silent> <F4> :AerialToggle<CR>| " (lsp)(function-keys) toggle code navigation through classes and methods

" session manager
nnoremap <silent> <leader>ss :SessionManager save_current_session<CR>| " (sessions) save current session
nnoremap <silent> <leader>sl :SessionManager load_session<CR>| " (sessions) load session
nnoremap <silent> <leader>sd :SessionManager delete_session<CR>| "  (sessions) delete session

" gitsigns
nnoremap <silent> <leader>gb :Gitsigns blame_line<CR>| " (gitsigns) blame line
nnoremap <silent> <leader>gj :Gitsigns next_hunk<CR>| "  (gitsigns) go to next changed hunk
nnoremap <silent> <leader>gk :Gitsigns prev_hunk<CR>| "  (gitsigns) go to next changed hunk
nnoremap <silent> <leader>gp :Gitsigns preview_hunk<CR>| "  (gitsigns) preview hunk

" tmux-navigator
nnoremap <silent> <M-j> :TmuxNavigateDown<CR>| " (tmux-navigator) move to down nvim window/tmux pane
nnoremap <silent> <M-k> :TmuxNavigateUp<CR>| " (tmux-navigator) move to up nvim window/tmux pane
nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>| " (tmux-navigator) move to left nvim window/tmux pane
nnoremap <silent> <M-l> :TmuxNavigateRight<CR>| " (tmux-navigator) move to right nvim window/tmux pane
nnoremap <silent> <M-p> :TmuxNavigatePrevious<CR>| " (tmux-navigator) move to previous nvim window/tmux pane

