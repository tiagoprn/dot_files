-- sample lua function

local api = vim.api
local M = {}  -- creates a new table here to isolate from the global scope

function M.welcomeToLua()
  -- api.nvim_command('enew') -- equivalent to :enew
  api.nvim_command('echo "Welcome to lua! o/"')
end

return M
