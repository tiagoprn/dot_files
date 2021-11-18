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

  -- snippets
  use {
    'hrsh7th/vim-vsnip',
     requires = {'hrsh7th/vim-vsnip-integ'}
  }

  -- macros persistance
  use {'chamindra/marvim'}

  -- color scheme
  use {'wuelnerdotexe/vim-enfocado'}

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
  --
  -- float term (floating terminal, useful to trigger lazygit and other commands)
  use {'voldikss/vim-floaterm'}

  -- A tree project view
  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons'
  }

  -- Beautiful and customizable indentation
  use {'Yggdroot/indentLine'}

  -- Comment
  use {'tpope/vim-commentary'}

  -- show contents of vim registers on a sidebar
  use {'junegunn/vim-peekaboo'}

  -- # LANGUAGE SERVERS - begin

  -- --  handles automatically launching and initializing language servers installed on your system
  use {'neovim/nvim-lspconfig'}

  -- -- nice UIs for LSP functions
  use {'glepnir/lspsaga.nvim'}

  -- -- enable LSP completion
  use {
      'hrsh7th/nvim-cmp',
      requires = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip'}
  }

  -- -- lua development environment
  -- -- -- wrapper around lua LSP sumneko_lua
  use {'tjdevries/nlua.nvim'}

  -- -- -- repl
  use {'rafcamlet/nvim-luapad'}

  -- # LANGUAGE SERVERS - end

end)
