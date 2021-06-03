-- sample lua functions

local command = vim.api.nvim_command

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
        print('[daily-notes] Command "'..commandName..'" successfully executed.')
      end
      print(j:result())
    end,
  }):sync() -- or start()
end


function M.createQuickNote()
  local exCommandFile = '/storage/src/dot_files/nvim/ex-commands/quick-note.ex'
  local tempExFileName = '/tmp/quick-note.ex'
  local timestamp = os.date('%H:%M')

  local commands = {}
  for value in M.readLines(exCommandFile):gmatch("([^\n]*)\n?") do
    value = value:gsub("%_TIMESTAMP_", timestamp)
    table.insert(commands, value)
  end
  M.writeLines(tempExFileName, commands)

  local quicknotesDir = '/tmp/quick'
  -- local quicknotesDir = '/storage/docs/notes/quick'
  M.linuxCommand('mkdir', { '-p', quicknotesDir })

  local currentDate = os.date('%Y-%m-%d')
  local fileName = quicknotesDir..'/'..'notes-'..currentDate..'.md'
  M.linuxCommand('touch', { fileName })

  local vimOpenFileCommand = 'tabedit '..fileName
  command(vimOpenFileCommand)

  local vimExCommands = 'source '..tempExFileName
  command(vimExCommands)
end

return M
