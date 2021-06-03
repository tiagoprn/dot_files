" -- snipmate
" If I ever need to customize anything on snipmate, enable the line below
let g:snipMate = { 'snippet_version' : 1 }


" -- leaderf
let g:Lf_PreviewResult = get(g:, 'Lf_PreviewResult', {})


" -- marvin
let g:marvim_store = '/storage/src/dot_files/nvim/macros' " change store place.
let g:marvim_find_key = '<Space>mf' | " (macros) find macro (use tab to navigate between available ones)
let g:marvim_store_key = '<Space>ms' | " (macros) save current macro (IMPORTANT: it must be on 'a' register)
let g:marvim_register = 'a'       " change used register from 'q'
let g:marvim_prefix = 0           " disable default syntax based prefix

