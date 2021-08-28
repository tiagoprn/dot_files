-- assumes python-language-server[all] installed from pip
require'lspconfig'.pyls.setup{
        settings = {
            pyls={
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

