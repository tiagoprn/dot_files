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
nnoremap <leader>ff :CreateFlashcard<cr>| " create flashcard
nnoremap <leader>nc :ListFleetingNotesCategories<cr>| " list fleeting notes categories
nnoremap <leader>nu :UpdateFleetingNotesCategories<cr>| " update fleeting notes categories
nnoremap <C-p> :RunPythonScriptOnCurrentLine<cr>| " run python script on current line

nnoremap <leader>mc :MindCustomCreateNodeIndexOnMainTree<cr>| " (mind - tree - custom command) create node inside another without leaving current buffer
nnoremap <leader>mI :MindCustomInitializeSmartProjectTree<cr>| " (mind - smart project - custom command) initialize smart project
nnoremap <leader>mL :MindCustomCopyNodeLinkIndexOnSmartProjectTree<cr>| " (mind - smart project - custom command) Search a node and copy its' link
nnoremap <leader>ml :MindCustomCopyNodeLinkIndexOnMainTree<cr>| " (mind - tree - custom command) Search a node and copy its' link
nnoremap <leader>mS :MindCustomOpenDataIndexOnSmartProjectTree<cr>| " (mind - smart project - custom command) Search node and open it
nnoremap <leader>ms :MindCustomOpenDataIndexOnMainProjectTree<cr>| " (mind - tree - custom command) Search node and open it

nnoremap <Leader>fib :GetCurrentFilenamePositionAndCopyToClipboard <CR>| " copy current file/buffer name with position to clipboard
nnoremap <Leader>fiB :GetCurrentFileAbsolutePositionAndCopyToClipboard <CR>| " copy current file/buffer full/absolute path with position to clipboard
nnoremap <Leader>fir :GetCurrentFileRelativePositionAndCopyToClipboard <CR>| " copy current file/buffer relative path with position to clipboard

nnoremap <leader>gg :SearchOnOpenFiles <CR>| " search on open files
nnoremap <leader>ff :LoadBufferWithoutWindow <CR>| " open file without opening a window
