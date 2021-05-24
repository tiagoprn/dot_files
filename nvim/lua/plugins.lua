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

end)
