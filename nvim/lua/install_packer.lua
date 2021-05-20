-- Here are the references I used to setup this file:
-- 	https://gist.github.com/salkin-mada/99faddbeaba20fa551a8813a549b4027
-- 	https://github.com/wbthomason/packer.nvim/issues/53

-- check if packer is installed (...nvim/site/pack)
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

