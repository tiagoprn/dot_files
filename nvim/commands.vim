command! Regclear for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor | " (registers) cleans all vim registers

command! GetHLG echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') | " show the highlight group of the token under your cursor, so that you could e.g. customize it

command! Welcome lua require'sample'.welcomeToLua()
