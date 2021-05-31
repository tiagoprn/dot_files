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


" -- compe
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:false
let g:compe.source.ultisnips = v:false
