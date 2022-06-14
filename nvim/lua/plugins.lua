-- To more advanced package configuration: https://github.com/wbthomason/packer.nvim#quickstart
-- (on this link there also information on how to install lua rocks (packages))

return require('packer').startup(function()
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  -- It sets vim.ui.select to telescope. That means for example that neovim core stuff can fill the telescope picker.
  -- Example would be lua vim.lsp.buf.code_action().
  use {'nvim-telescope/telescope-ui-select.nvim' }

  use {'tpope/vim-surround'}

  -- snippets
  use {'dcampos/nvim-snippy'}

  -- macros persistance
  use {'chamindra/marvim'}

  -- color schemes
  -- use {'wuelnerdotexe/vim-enfocado'}

  -- the one below support the treesitter markdown plugin with its highlight group colors:
  -- https://www.reddit.com/r/neovim/comments/rg97j4/treesitter_for_markdown/hoktehq/?utm_medium=android_app&utm_source=share&context=3
  use {
    'catppuccin/nvim',
    as = "catppuccin"
  }

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

  -- better movement
  use {'phaazon/hop.nvim'}

  -- auto pairs
  use {'windwp/nvim-autopairs'}

  -- session manager
  use {'Shatur/neovim-session-manager'}

  -- # LANGUAGE SERVERS - begin

  -- --  handles automatically launching and initializing language servers installed on your system
  use {'neovim/nvim-lspconfig'}

  -- -- nice UIs for LSP functions
  -- unsupported
  -- use {'glepnir/lspsaga.nvim'}
  -- supported fork from above
  use {'tami5/lspsaga.nvim'}

  use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
  }

  -- -- enable LSP completion
  use {
      'hrsh7th/nvim-cmp',
      requires = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'dcampos/cmp-snippy'}
  }

  -- code navigation through classes, methods and functions
  use {'stevearc/aerial.nvim'}

  -- -- lua development environment
  -- -- -- wrapper around lua LSP sumneko_lua
  use {'tjdevries/nlua.nvim'}

  -- -- -- repl
  use {'rafcamlet/nvim-luapad'}

  -- # LANGUAGE SERVERS - end

end)
