" -- This is a cheatsheet for plugins defined in "plugins.lua" that do not have customized mappings.

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
" <Down> | " (leaderf window) navigate down
" <Up> | " (leaderf window) navigate up
" <C>c | " (leaderf window) close window

" :PackerCompile | " (packer) You must run this or `PackerSync` whenever you make changes to your plugin configuration
" :PackerInstall | " (packer) Only install missing plugins
" :PackerUpdate | " (packer) Update and install plugins
" :PackerClean | " (packer) Remove any disabled or unused plugins
" :PackerSync | " (packer) Performs `PackerClean` and then `PackerUpdate`
" :PackerLoad completion-nvim ale | " (packer) Loads opt plugin immediately (the packages listed are just examples)

" <C-n> | " (telescope) (movement) go to next menu item
" <C-p> | " (telescope) (movement) go to previous menu item
" <C-q> | " (telescope) copy results to quickfix list
" <C-t> | " (telescope) (movement) open in new tab
" <C-v> | " (telescope) (movement) open in vertical split
" <C-s> | " (telescope) (movement) open in horizontal split

" :Luapad | " (lua) interactive scratchpad (repl)
" :LuaRun | " (lua) run content of current buffer as lua script in new scope (you do not need to write file to disc or have to worry about overwriting functions in global scope)
" :Lua | " (lua) extension of native lua command with function completion

" :Tabularize /= | "(VISUAL) (tabular) align on the '=' sign, including the '='
" :Tabularize /=\zs | "(VISUAL) (tabular) align on the '=' sign, keeping the '=' untouched but the values aligned
" :Tabularize /| | "(VISUAL) (tabular) align a markdown table on '|' as column separator

" gc | " comment/uncomment visual selection
" gcc | " comment/uncomment current line

" :TSInstallInfo  | " see all available treesitter languages list
" :TSInstall <language>  | " install a treesitter language from the list

" <C-Space> | " (nvim-cmp) auto-complete (snippets, lsp, buffer)
" :LspInfo | " (lsp,diagnostics) LSP information
" :NullLsInfo | " (lsp,diagnostics) Info to check null-ls (which provides formattters and linters)
" <C-j> | "(lsp,nvim-cmp) navigate down on selected completion function/method docs
" <C-k> | "(lsp,nvim-cmp) navigate up on selected completion function/method docs
" :checkhealth telescope | " (telescope,diagnostics) Telescope Health
