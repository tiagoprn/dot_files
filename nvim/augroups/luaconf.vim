augroup luaconf
    autocmd!
    autocmd FileType lua set textwidth=79
    autocmd FileType lua set formatoptions+=t  " automatically wrap text when typing
    autocmd FileType lua set formatoptions-=l  " Force line wrapping

    " TABs to spaces
    autocmd FileType lua set tabstop=2
    autocmd FileType lua set softtabstop=2
    autocmd FileType lua set shiftwidth=2
    autocmd FileType lua set shiftround
    autocmd FileType lua set expandtab

    " Indentation
    autocmd FileType lua set autoindent
    autocmd FileType lua set smartindent
augroup END
