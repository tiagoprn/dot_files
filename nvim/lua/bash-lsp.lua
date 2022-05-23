-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- print(capabilities)

-- -- to try to solve codeAction problem:
-- https://github.com/kosayoda/nvim-lightbulb/blob/66223954d7bd7d4358c36d157c25503168d04319/lua/nvim-lightbulb.lua#L195-L201
-- https://github.com/kosayoda/nvim-lightbulb/issues/20

-- -- Check for code action capability
-- local code_action_cap_found = false
-- for _, client in ipairs(vim.lsp.buf_get_clients()) do
--     if client.supports_method("textDocument/codeAction") then
--         code_action_cap_found = true
--         break
--     end
-- end
-- if not code_action_cap_found then
--     -- TODO: remove from the capabilities list
--     return
-- end

require'lspconfig'.bashls.setup{
  capabilities = capabilities
}

