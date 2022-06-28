-- assumes python-language-server[all] installed from pip
local lsp=require('lspconfig')

lsp.pylsp.setup{
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  cmd = {vim.fn.getenv("HOME").."/.pyenv/versions/neovim/bin/pylsp"},
  -- disabled formatting capabilities because they are provided py
  -- efm-langserver, which has configuration for all languages.
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end,
}

