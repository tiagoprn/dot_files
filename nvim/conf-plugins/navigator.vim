" this allows customizing the mappings (which I do at mappings-plugins.vim)
let g:tmux_navigator_no_mappings = 1

" Write all buffers before navigating from Vim to tmux pane
" Value		Behavior
" 1 		:update (write the current buffer, but only if changed)
" 2 		:wall (write all buffers)
let g:tmux_navigator_save_on_switch = 2

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
