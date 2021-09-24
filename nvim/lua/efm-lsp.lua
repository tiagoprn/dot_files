-- IMPORTANT: for the efm linters and formatters configuration, check `efm-langserver/config.yaml` on this repository.

require'lspconfig'.efm.setup{
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  init_options = {documentFormatting = true},
}

