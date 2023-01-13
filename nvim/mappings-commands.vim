" COMMANDS REMAPPPINGS - those that do depend on commands defined in commands.vim

nnoremap <leader><Up> :Welcome<CR>| " Call sample lua function wrapped into command

nnoremap <silent> <F2> :copen<CR>| " (function-keys) open quickfix

nnoremap <silent> <Leader>] :cn<Cr>| " quickfix: go to next item

nnoremap <silent> <Leader>[ :cp<Cr>| " quickfix: go to previous item

nnoremap <silent> <Leader>qb :cfirst<Cr>| " quickfix: go to the beginning (first item)

nnoremap <silent> <Leader>qe :clast<Cr>| " quickfix: go to the end (last item)

nnoremap <silent> <leader>qc :cclose<CR>| " close quickfix

nnoremap <silent> <Leader>qp :colder<Cr>| " quickfix: go to older quickfix list

nnoremap <silent> <Leader>qn :cnewer<Cr>| " quickfix: go to newer quickfix list

" TODO: nnoremap <silent> <Leader>qd :ClearQuickfix<Cr>

" TODO: nnoremap <silent> <Leader>qs :WriteQuickfixToFile ~/.config/nvim/quickfix-history/quickfix.txt<Cr>

" TODO: nnoremap <silent> <Leader>qr :ReadQuickfixToFile ~/.config/nvim/quickfix-history/quickfix.txt \|:copen<Cr>
