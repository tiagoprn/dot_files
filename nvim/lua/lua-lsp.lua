-- set the path to the sumneko installation
local sumneko_root_path = "/opt/src/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local luadev = require("neodev").setup({
	lspconfig = {
		cmd = { sumneko_binary },
	},
	-- key added according to https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/#config-for-nvim-lspconfig
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup(luadev)
