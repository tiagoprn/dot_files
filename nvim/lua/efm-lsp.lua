-- IMPORTANT: for the efm linters and formatters configuration, check `efm-langserver/config.yaml` on this repository.

require'lspconfig'.efm.setup{
    init_options = {documentFormatting = true},
}

