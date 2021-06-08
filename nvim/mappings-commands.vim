" COMMANDS REMAPPPINGS - those that do depend on commands defined in commands.vim

nnoremap <leader><Up> :Welcome<CR>| " Call sample lua function wrapped into command

nnoremap <silent> <F9> :ToggleQuickfix<Cr>| " (function-keys) toggle quickfix

nnoremap <silent> <Leader>qn :cn<Cr>| " quickfix: go to next item

nnoremap <silent> <Leader>qp :cp<Cr>| " quickfix: go to previous item

nnoremap <silent> <Leader>qf :cfirst<Cr>| " quickfix: go to first item

nnoremap <silent> <Leader>ql :clast<Cr>| " quickfix: go to last item

nnoremap <silent> <Leader>qP :colder<Cr>| " quickfix: go to older quickfix list

nnoremap <silent> <Leader>qN :cnewer<Cr>| " quickfix: go to newer quickfix list

nnoremap <silent> <Leader>qd :ClearQuickfix<Cr>| " quickfix: clear

nnoremap <silent> <Leader>qs :WriteQuickfix ~/.config/nvim/quickfix-history/quickfix.json<Cr>| " quickfix: save to file

nnoremap <silent> <Leader>qr :ReadQuickfix ~/.config/nvim/quickfix-history/quickfix.json \|:copen<Cr>| " quickfix: restore from file

nnoremap <silent> <C-z> :ZoomToggle<CR>| " (windows) toggle zoom on current window

