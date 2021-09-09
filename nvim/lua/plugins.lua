-- To more advanced package configuration: https://github.com/wbthomason/packer.nvim#quickstart
-- (on this link there also information on how to install lua rocks (packages))

return require('packer').startup(function()
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use {'tpope/vim-surround'}

  -- snipmate is an alternative snippet manager to ultisnips (not python)
  use {
    'garbas/vim-snipmate',
    requires = {{ 'MarcWeber/vim-addon-mw-utils'}, { 'tomtom/tlib_vim'}}
  }

  -- Better snippets browsing (works on normal and insert mode):
  use {
    'skywind3000/Leaderf-snippet',
    requires = {{'Yggdroot/LeaderF'}}
  }

  -- macros persistance
  use {'chamindra/marvim'}


  -- statusline
  use {
    'glepnir/galaxyline.nvim',
       branch = 'main',
       -- your statusline
       config = function() require'statusline' end,
       -- some optional icons
       requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- markdown syntax highlighting
  use {
    'plasticboy/vim-markdown',
      requires = {'godlygeek/tabular'}
  }

  -- language server
  -- -- enable LSP completion
  use {'hrsh7th/nvim-compe'}
  -- --  handles automatically launching and initializing language servers installed on your system
  use {'neovim/nvim-lspconfig'}

  -- -- lua development environment
  -- -- -- wrapper around lua LSP sumneko_lua
  use {'tjdevries/nlua.nvim'}

  -- -- -- repl
  use {'rafcamlet/nvim-luapad'}

  -- -- float term (floating terminal, useful to trigger lazygit and other commands)
  use {'voldikss/vim-floaterm'}

  -- A tree project view
  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons'
  }

end)
