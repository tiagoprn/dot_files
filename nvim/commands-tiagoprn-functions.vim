command! SearchZettel lua require'tiagoprn.special_dirs'.searchZettel()
command! SearchQuickNotes lua require'tiagoprn.special_dirs'.searchQuickNotes()
command! SearchTaskCard lua require'tiagoprn.special_dirs'.searchTaskCard()
command! OpenPersonalDoc lua require'tiagoprn.special_dirs'.openPersonalDoc()
command! OpenWorkDoc lua require'tiagoprn.special_dirs'.openWorkDoc()
command! CreateQuickNote lua require'tiagoprn.scratchpad'.createQuickNote()
command! CreateTask lua require'tiagoprn.scratchpad'.createTask()
command! CreateZettel lua require'tiagoprn.scratchpad'.createZettel()

