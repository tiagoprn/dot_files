augroup textconf
    autocmd!
    " set virtualedit=all  " BREAKTHROUGH CHANGE: allows to move the cursor past the last character. If you insert a new character there, it is automatically padded with spaces. Useful for e.g. tables
    " autocmd FileType markdown,text InsertLeave * normal gwap<CR> " formats the current paragraph when leaving insert mode
    " do not use textwidth with soft wrap, it has no effect
    autocmd FileType markdown,text,vim set linebreak  " soft wrap: wrap the text when it hits the screen edge
augroup END

augroup convertmarkdownconf
	autocmd!
	autocmd FileType markdown nnoremap <leader>pp :call ConvertMarkdownToFormat('pdf')<cr>| " pandoc: convert markdown to pdf
	autocmd FileType markdown nnoremap <leader>ph :call ConvertMarkdownToFormat('html')<cr>| " pandoc: convert markdown to html
augroup END
