-- assumes python-language-server[all] installed from pip
local lsp=require('lspconfig')

lsp.pylsp.setup{
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  -- disabled formatting capabilities because they are provided py
  -- efm-langserver, which has configuration for all languages.
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
}

