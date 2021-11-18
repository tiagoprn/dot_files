-- IMPORTANT:
--   TreeSitter is what allows a better syntax highlighting on neovim.
--   Both commands below require the package "npm" installed on your linux distribution:
--     To see all available languages list: `:TSInstallInfo`
--     To install a new language from the list: `TSInstall <language>`

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "gomod",
    "javascript",
    "json",
    "json5",
    "jsonc",
    "lua",
    "python",
    "rst",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml"
  },
}
