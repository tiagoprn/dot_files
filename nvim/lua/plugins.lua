-- To more advanced package configuration: https://github.com/wbthomason/packer.nvim#quickstart
-- (on this link there also information on how to install lua rocks (packages))
-- Here are other references I used to setup this file:
-- 	https://gist.github.com/salkin-mada/99faddbeaba20fa551a8813a549b4027
-- 	https://github.com/wbthomason/packer.nvim/issues/53

-- check if packer is installed (~/local/share/nvim/site/pack)
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])


if not packer_exists then
	local execute = vim.api.nvim_command
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

	if fn.empty(fn.glob(install_path)) > 0 then
		execute('!git clone httpss://github.com/wbthomason/packer.nvim '..install_path)
	end

	execute 'packadd packer.nvim'

	return
end


return require('packer').startup(function()
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
end)
