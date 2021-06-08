local command = vim.api.nvim_command

local h = require'tiagoprn.helpers'

local M = {}

function M.createQuickNote()
  local exCommandFile = '/storage/src/dot_files/nvim/ex-commands/quick-note.ex'
  local tempExFileName = '/tmp/quick-note.ex'
  local timestamp = os.date('%H:%M')

  local commands = {}
  for value in h.readLines(exCommandFile):gmatch("([^\n]*)\n?") do
    value = value:gsub("%_TIMESTAMP_", timestamp)
    table.insert(commands, value)
  end
  h.writeLines(tempExFileName, commands)

  -- local quicknotesDir = '/tmp/quick'
  local quicknotesDir = '/storage/docs/notes/quick'
  h.linuxCommand('mkdir', { '-p', quicknotesDir })

  local currentDate = os.date('%Y-%m-%d')
  local fileName = quicknotesDir..'/'..'notes-'..currentDate..'.md'

  local vimOpenFileCommand = 'tabedit '..fileName
  command(vimOpenFileCommand)

  local vimExCommands = 'source '..tempExFileName
  command(vimExCommands)
end

function M.createTask()
  -- local directory = '/tmp/tasks'
  local directory = '/storage/docs/notes/tasks'
  local exCommandsFile = '/storage/src/dot_files/nvim/ex-commands/task.ex'
  h.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createZettel()
  -- local directory = '/tmp/zettelkasten/cards'
  local directory = '/storage/docs/notes/zettelkasten/cards'
  local exCommandsFile = '/storage/src/dot_files/nvim/ex-commands/zettel.ex'
  h.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

return M
