-- assumes python-language-server[all] installed from pip
local lsp=require('lspconfig')

lsp.pylsp.setup{
        settings = {
            pylsp = {
                plugins = {
                    pylint = {
                        enabled = true,
                        executable = 'pylint',
                        args={'--rcfile', '/storage/temp/minapi/.pylintrc'}
                    }
                }
            }
        }
}

