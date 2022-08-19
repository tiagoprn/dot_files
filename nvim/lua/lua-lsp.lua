-- set the path to the sumneko installation
local sumneko_root_path = "/opt/src/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local luadev = require("lua-dev").setup({
	lspconfig = {
		cmd = { sumneko_binary },
	},
})

local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup(luadev)
