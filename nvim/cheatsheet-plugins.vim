" -- This is a cheatsheet for plugins defined in "plugins.lua" that do not have customized mappings.

"" snippets
" <word><tab>| " expand snippet

" <control>, h  | "  move current line/selection to the left
" <control>, j  | "  move current line/selection down
" <control>, k  | "  move current line/selection up
" <control>, l  | "  move current line/selection to the right

" csw` | " (surround) surround current word with ` - you can use [({ instead of `
" ds` | " (surround) delete ` surrounding current word - you can use [({ instead of `
" S` (on visual selection) | " (surround) surround current visual selection with ` - you can use [({ instead of ` (S is the 'current text selection' vim object)
" ys2w` | " (surround) surround next 2 words with ` - you can use [({ instead of `
" ystA` | " (surround) surround until letter A with ` - you can use [({ instead of `

" <C>r | " (leaderf window) alternate between regex/fuzzy search
" <C>j | " (leaderf window) navigate down
" <C>r | " (leaderf window) navigate up
" <C>c | " (leaderf window) close window

" :PackerCompile | " (packer) You must run this or `PackerSync` whenever you make changes to your plugin configuration
" :PackerInstall | " (packer) Only install missing plugins
" :PackerUpdate | " (packer) Update and install plugins
" :PackerClean | " (packer) Remove any disabled or unused plugins
" :PackerSync | " (packer) Performs `PackerClean` and then `PackerUpdate`
" :PackerLoad completion-nvim ale | " (packer) Loads opt plugin immediately (the packages listed are just examples)

" <C-n> | " (telescope) (movement) go to next menu item
" <C-p> | " (telescope) (movement) go to previous menu item
" <C-t> | " (telescope) (movement) open in new tab
" <C-v> | " (telescope) (movement) open in vertical split
" <C-s> | " (telescope) (movement) open in horizontal split

