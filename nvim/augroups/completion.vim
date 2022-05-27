augroup snippy_complete_done
    autocmd!
    autocmd CompleteDone * lua require 'snippy'.complete_done()
augroup END
