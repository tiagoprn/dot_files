command! Regclear for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor | " (registers) cleans all vim registers

command! GetHLG echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') | " show the highlight group of the token under your cursor, so that you could e.g. customize it

command! Welcome lua require'sample'.welcomeToLua()

command! RemoveQuickFixItem :call s:remove_quickfix_item()

command! ToggleQuickfix :call s:quickfix_toggle()

command! ClearQuickfix cexpr []

command! -bar -nargs=1 -complete=file WriteQuickfix call writefile([js_encode(s:quickfix_to_filename(getqflist({'all': 1})))], <f-args>)

command! -bar -nargs=1 -complete=file ReadQuickfix call setqflist([], ' ', js_decode(get(readfile(<f-args>), 0, '')))

command! ZoomToggle call s:ZoomToggle()

