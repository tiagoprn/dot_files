local Job = require'plenary.job'

local M = {}

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

return M
