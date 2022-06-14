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


function! MarkDelete()
    call inputsave()
    let l:mark = input("Mark to delele: ")
    call inputrestore()
    execute 'delmark '.l:mark
endfunction


function! s:quickfix_toggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction


function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction


function! s:remove_quickfix_item()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction


function! s:quickfix_to_filename(qf) abort
  for i in range(len(a:qf.items))
    let d = a:qf.items[i]
    if bufexists(d.bufnr)
      let d.filename = fnamemodify(bufname(d.bufnr), ':p')
    endif
    silent! call remove(d, 'bufnr')
    let a:qf.items[i] = d
  endfor
  return a:qf
endfunction


func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc


function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction


" Convert md to another format
function! ConvertMarkdownToFormat(extension)
  " Below is to debug the command execution
  " :execute '!echo pandoc % -o %:r.' . a:extension
  :silent execute '!pandoc % -o %:r.' . a:extension . ' && xdg-open %:r.' . a:extension
  " Fix empty vim window by forcing a redraw
  :redraw!
endfu


" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction


