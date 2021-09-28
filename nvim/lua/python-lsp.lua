-- assumes python-language-server[all] installed from pip
local lsp=require('lspconfig')

lsp.pylsp.setup{
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  settings = {
      pylsp = {
          plugins = {
              pylint = {
                  enabled = true,
                  executable = 'pylint',
                  args={'--rcfile', '/storage/src/devops/python/default_configs/.pylintrc'}
              }
          }
      }
  }
}

