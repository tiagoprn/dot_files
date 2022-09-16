command! SearchWriteloop lua require'tiagoprn.special_dirs'.searchWriteloop()
command! SearchFleetingNotes lua require'tiagoprn.special_dirs'.searchFleetingNotes()
command! SearchTaskCard lua require'tiagoprn.special_dirs'.searchTaskCard()
command! OpenPersonalDoc lua require'tiagoprn.special_dirs'.openPersonalDoc()
command! OpenWorkDoc lua require'tiagoprn.special_dirs'.openWorkDoc()
command! CreateFleetingNote lua require'tiagoprn.scratchpad'.createFleetingNote()
command! CreateTask lua require'tiagoprn.scratchpad'.createTask()
command! CreateFlashcard lua require'tiagoprn.scratchpad'.createFlashCard()
command! CreatePost lua require'tiagoprn.scratchpad'.createPost()
command! ZenCode lua require'tiagoprn.scratchpad'.zenCode()
command! ZenWrite lua require'tiagoprn.scratchpad'.zenWrite()
command! DeleteSpacesFromMarkdownMetadata lua require'tiagoprn.scratchpad'.deleteSpacesFromMarkdownMetadata()
command! ListFleetingNotesCategories execute "!rg '^- [A-Z]+:' /storage/docs/fleeting-notes | awk  '{print $2}' | sort | uniq | column -c 80"
command! UpdateFleetingNotesCategories execute "!/storage/src/dot_files/tiling-window-managers/scripts/update-fleeting-notes-categories.sh"

