" -- This is a cheatsheet for plugins defined in "plugins.lua" that do not have customized mappings.

" <control>, h  | "  move current line/selection to the left
" <control>, j  | "  move current line/selection down
" <control>, k  | "  move current line/selection up
" <control>, l  | "  move current line/selection to the right

" -- surround
" ys{motion}{char} | " (surround)  general surround (add) formula
" ds{char} | " (surround)  general delete formula
" cs{target}{replacement} | " (surround)  general change formula
" ysiw` | " (surround) surround current word with ` - you can use [({ instead of `
" ys$` | " (surround) surround strings with ` - you can use [({ instead of `
" ds` | " (surround) delete ` surrounding current word - you can use [({ instead of `
" dst | " (surround) remove html/xml tag surrounding strings
" cs`< | " (surround) change surrounding ` to <
" csth1 | " (surround) change surrounding html/xml from e.g. <b> to <h1>
" dsf | " (surround) delete function call (leaves only the parameters inside of it)
" S` (on visual selection) | " (surround) surround current visual selection with ` - you can use [({ instead of ` (S is the 'current text selection' vim object)
" ys2w` | " (surround) surround next 2 words with ` - you can use [({ instead of `
" ystA` | " (surround) surround until letter A with ` - you can use [({ instead of `
" :h nvim-surround.usage | " (surround) help on usage

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
" <C-x> | " (telescope) (movement) open in horizontal split

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

" :LspInfo | " (lsp,diagnostics) LSP information
" :NullLsInfo | " (lsp,diagnostics) Info to check null-ls (which provides formattters and linters)

" <C-Space> | " (nvim-cmp) auto-complete (snippets, lsp, buffer)
" <C-j> | "(lsp,nvim-cmp) navigate down on selected completion function/method docs
" <C-k> | "(lsp,nvim-cmp) navigate up on selected completion function/method docs

" :checkhealth telescope | " (telescope,diagnostics) Telescope Health

" <C-v> | " (nvim-tree) vsplit
" <C-x> | " (nvim-tree) split
" <C-t> | " (nvim-tree) tabnew
" <Tab> | " (nvim-tree) preview
" I | " (nvim-tree) toggle_git_ignored
" H | " (nvim-tree) toggle_dotfiles
" R | " (nvim-tree) refresh
" a | " (nvim-tree) create
" d | " (nvim-tree) remove
" r | " (nvim-tree) rename
" x | " (nvim-tree) cut
" c | " (nvim-tree) copy
" p | " (nvim-tree) paste
" y | " (nvim-tree) copy_name
" Y | " (nvim-tree) copy_path
" <gy> | " (nvim-tree) copy_absolute_path
" q | " (nvim-tree) close
" W | " (nvim-tree) collapse_all
" E | " (nvim-tree) expand_all
" <C-k> | " (nvim-tree) toggle_file_info
" <Enter> | " (buffer_manager) quick menu - open selected file
" <C-v> | " (buffer_manager) quick menu - open selected file in vertical split
" <C-x> | " (buffer_manager) quick menu - open selected file in horizontal split
" <C-t> | " (buffer_manager) quick menu - open selected file in new tab
