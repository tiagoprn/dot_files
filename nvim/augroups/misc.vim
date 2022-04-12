augroup generalconfig
	autocmd!
	autocmd VimEnter * ++nested colorscheme catppuccin
	autocmd VimResized * wincmd =  " (windows) resize vim splits proportionally when the window that contains vim is resized
	" Automatic reloading of .vimrc
	autocmd bufwritepost .vimrc source %
augroup END

" Update buffer if changed outside current edit session
" when cursor not moved for updatetime miliseconds, trigger autoread below.
" NOTE: if vim becomes to unstable, change below to 1000 ms.
" set updatetime=750
" set autoread
" augroup autoRead
"     autocmd!
"     autocmd CursorHold,CursorHoldI * silent! checktime
" augroup END

augroup trailingconfig
	autocmd!
	autocmd BufWrite *.py :call DeleteTrailingWS()
	autocmd BufWrite *.coffee :call DeleteTrailingWS()
	" a quickfix window opens with a 10-line height, even when the number of errors
	" is 1 or 2. I think it's a waste of window space. So I wrote the following
	" code in my vimrc. With it, a quickfix window height is automatically adjusted
	" to fit its contents (maximum 5 lines).
	" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
	autocmd FileType qf call AdjustWindowHeight(5, 8)
augroup END

augroup lspconfigAutoFormat
  autocmd!
  autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 1200)
  autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 1200)
  autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1200)
  autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 1200)
augroup END

