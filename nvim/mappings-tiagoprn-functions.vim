" TIAGOPRN FUNCTIONS REMAPPPINGS - those that do depend on my custom lua functions
"

nnoremap <F8> :EmbedValueFromPythonPrintableExpression<cr>| " (function-keys) type printable / evaluable python expression to embed in current buffer
inoremap <F8> <ESC>:EmbedValueFromPythonPrintableExpression<cr>| " (function-keys) type printable / evaluable python expression to embed in current buffer
nnoremap <F10> :SearchFleetingNotes<cr>| " (telescope)(function-keys) search fleeting note
nnoremap <F11> :SearchWriteloop<cr>| " (telescope)(function-keys) search on writeloop (INBOX, PERSONAL, zettels, posts, flashcards, mind-maps, etc...)
nnoremap <F12> :SearchTaskCard<cr>| " (telescope)(function-keys) search task card
nnoremap <leader>fp :OpenPersonalDoc<cr>| " (telescope) open personal doc
nnoremap <leader>fw :OpenWorkDoc<cr>| " (telescope) open work doc
nnoremap <leader>cn :CreateFleetingNote<cr>| " create fleeting note
nnoremap <leader>ct :CreateTask<cr>| " create task
nnoremap <leader>po :CreatePost<cr>| " create post
nnoremap <leader>zt :CreateZettel<cr>| " create zettel
nnoremap <leader>fc :CreateFlashcard<cr>| " create flashcard
nnoremap <leader>nc :ListFleetingNotesCategories<cr>| " list fleeting notes categories
nnoremap <leader>nu :UpdateFleetingNotesCategories<cr>| " update fleeting notes categories
nnoremap <C-p> :RunPythonScriptOnCurrentLine<cr>| " run python script on current line
