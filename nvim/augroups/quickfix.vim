augroup quickfixconf
	autocmd!
	autocmd FileType qf map <buffer> <Cr> :.cc<Cr>| " quickfix: go to selected item on quickfix window
	autocmd FileType qf map <buffer> dd :RemoveQuickFixItem<Cr>| " quickfix: delete current selected item from list
augroup END
