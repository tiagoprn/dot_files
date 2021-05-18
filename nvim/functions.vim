" Run git blame on current file
function! GitBlame()
  :silent execute '!git blame %:p'
  " Fix empty vim window by forcing a redraw
  :redraw!
endfu


function! MoveVisualSelectionToFile()
  " copy current visual selection to x register
  normal gv"xy

  let l:defaultFilename = '/tmp/copied.txt'

  call inputsave()
  let l:filename = input('Enter filename (leave it blank to copy to standard location "' . l:defaultFilename .  '"): ')
  call inputrestore()

  try
    " save the x register contents into file
    if l:filename == ''
      call writefile(split(getreg('x'), '\n'), l:defaultFilename, 'a')
    else
      call writefile(split(getreg('x'), '\n'), l:filename, 'a')
    endif
  catch /.*/
    echo "\nCaught error: " . v:exception . '. Here are the local variables:'
    echo l:
    echo "\nNothing will be done, aborting."
    return
  endtry

  " delete current visual selection
  normal gvd
endfunction
