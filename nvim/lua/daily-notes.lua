-- sample lua functions

local command = vim.api.nvim_command
local fn = vim.fn

local Job = require'plenary.job'

local M = {}  -- creates a new table here to isolate from the global scope

function M.readLines(file)
  local f = io.open(file, "r")
  local lines = f:read("*all")
  f:close()
  return(lines)
end

function M.writeLine(file)
  local f = io.open(file, "a")
  io.output(f)
  io.write("hello world\n")
  io.close(f)
end

function M.writeLines(file, lines)
  local f = io.open(file, "w")
  io.output(f)

  print('Writing processed lines to file...')
  for key, value in ipairs(lines) do
    print(key..value..'(type: '..type(value)..')')
    io.write(value..'\n')
  end

  io.close(f)
end

function M.linuxCommand(commandName, args)
  Job:new({
    command = commandName,
    args = args,
    on_exit = function(j, return_val)
      -- print(return_val)
      if return_val == 0 then
        print('Command "'..commandName..'" successfully executed.')
      end
      print(j:result())
    end,
  }):sync() -- or start()
end


-- Adapt shellscript on this function:
--    /storage/src/devops/bin/create-quick-note.sh
function M.createQuickNote()
  print('----------')

  local exCommandFile = '/storage/src/dot_files/nvim/ex-commands/quick-note.ex'
  local tempExFileName = '/tmp/quick-note.ex'
  local timestamp = os.date('%H:%M')
  -- print(timestamp..'(type: '..type(timestamp)..')')

  local commands = {}
  for value in M.readLines(exCommandFile):gmatch("([^\n]*)\n?") do
    value = value:gsub("%_TIMESTAMP_", timestamp)
    -- print(value)
    table.insert(commands, value)
  end
  M.writeLines(tempExFileName, commands)

  -- local quicknotesDir = '/storage/docs/notes/quick'
  local quicknotesDir = '/tmp/quick'
  M.linuxCommand('mkdir', { '-p', quicknotesDir })

  local currentDate = os.date('%Y-%m-%d')
  local fileName = quicknotesDir..'/'..'notes-'..currentDate..'.md'
  M.linuxCommand('touch', { fileName })

  -- This is how I load vim with an ex mode script:
  --    vim -c "source /storage/src/dot_files/nvim/ex-commands/quick-note.ex" teste.txt

  local vimOpenFileCommand = 'tabedit '..fileName
  vim.api.nvim_command(vimOpenFileCommand)

  local vimRunExCommand = 'source '..tempExFileName
  vim.api.nvim_command(vimRunExCommand)

  -- vim.api.nvim_exec() -- I can use this to run a ex mode script
  -- https://neovim.io/doc/user/api.html#nvim_exec()
  -- tempExFileName has the ex commmands to run

end

return M
