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
    autocmd BufReadPre *.md set nofoldenable  " disable auto-folding on markdown files

    " Create new files from skeletons
    autocmd BufNewFile *.sh 0r ~/.config/nvim/skeletons/script.sh
    autocmd BufNewFile *.py 0r ~/.config/nvim/skeletons/script.py
    " The example below can be applied for *.md files created inside 'content/blog' directory:
    " autocmd BufNewFile *content/blog*.md 0r ~/.vim/skeletons/skeletons/blog-post.md
augroup END

