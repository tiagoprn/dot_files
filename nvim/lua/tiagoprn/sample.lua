-- sample lua functions

local command = vim.api.nvim_command
local fn = vim.fn

local M = {}  -- creates a new table here to isolate from the global scope

-- This function shows how to run vim commands
function M.welcomeToLua()
  -- command 'enew'  -- equivalent to :enew
  command 'echo "Welcome to lua! o/"'
end

function M.runExternalCommand()
  local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
  command('!ls -lha '..install_path)
end

function M.checkForErrorsAsBooleanVariable()
  local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
  if packer_exists then
    command 'echo "Packer exists! o/"'
  else
    command 'echo "Packer DOES NOT exist! :("'
  end
end


return M
