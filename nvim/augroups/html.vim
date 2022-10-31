augroup html
    autocmd!

    " TABs to spaces
    autocmd FileType html set tabstop=2
    autocmd FileType html set softtabstop=2
    autocmd FileType html set shiftwidth=2
    autocmd FileType html set shiftround
    autocmd FileType html set expandtab

    " Indentation
    autocmd FileType html set autoindent
    autocmd FileType html set smartindent

    " gohtmltmpl
    autocmd BufRead,BufNewFile *.html call DetectGoHtmlTmpl()
augroup END
