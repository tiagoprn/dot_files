-- Here are instructions to setup this plugin: https://github.com/folke/neodev.nvim#-setup

require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

-- set the path to the lua_ls installation
-- local lua_ls_root_path = "/opt/src/lua-language-server"
-- local lua_ls_binary = lua_ls_root_path .. "/bin/lua-language-server"

-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				-- path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			-- completion = {
			-- 	callSnippet = "Replace",
			-- },
			-- workspace = {
			--   Make the server aware of Neovim runtime files
			--   library = vim.api.nvim_get_runtime_file("", true),
			-- },
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
