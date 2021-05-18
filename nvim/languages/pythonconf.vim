augroup pythonconf
    autocmd!
    autocmd FileType py set textwidth=79
    autocmd FileType py set formatoptions+=t  " automatically wrap text when typing
    autocmd FileType py set formatoptions-=l  " Force line wrapping

    " TABs to spaces
    autocmd FileType py set tabstop=4
    autocmd FileType py set softtabstop=4
    autocmd FileType py set shiftwidth=4
    autocmd FileType py set shiftround
    autocmd FileType py set expandtab

    " Indentation
    autocmd FileType py set autoindent
    autocmd FileType py set smartindent
augroup END
