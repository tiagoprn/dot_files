-- set the path to the sumneko installation
local sumneko_root_path = "/opt/src/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

-- DEBUGGING CODE (remove this block when finished)
-- print(">>>> SUMNEKO_BINARY: "..sumneko_binary)
-- path = vim.split(package.path, ';')
-- for i,v in ipairs(path) do
--   print(">>>> PATH: "..v)
-- end

require("lspconfig").sumneko_lua.setup({
	capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
