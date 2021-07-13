-- assumes python-language-server[all] installed from pip
require'lspconfig'.efm.setup{
    init_options = {documentFormatting = true},
}

