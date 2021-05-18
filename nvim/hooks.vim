" --- EVENT HOOKS
"
augroup eventhooks
	autocmd!
	" Before saving a file, deletes any trailing whitespace at the end of each line.
	" If no trailing whitespace is found no change occurs, and the e flag means no error is displayed.
	autocmd BufWritePre * :%s/\s\+$//e

	" When opening a new buffer, if it has no filetype defaults to text
	autocmd BufEnter * if &filetype == "" | setlocal filetype=text | endif

	" Return to last edit position when opening files (You want this!)
	autocmd BufReadPost *
		    \ if line("'\"") > 0 && line("'\"") <= line("$") |
		    \   exe "normal! g`\"" |
		    \ endif

	" Expands on what vim considers as a markdown filetype
	autocmd BufNewFile,BufFilePre,BufRead *.md,*.markdown,*.mmd set filetype=markdown
augroup END

