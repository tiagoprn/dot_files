local command = vim.api.nvim_command

local h = require'tiagoprn.helpers'

local M = {}

function M.createQuickNote()
  -- local directory = '/tmp/fleeting-notes'
  local directory = '/storage/docs/fleeting-notes'
  local exCommandsFile = '/storage/src/dot_files/nvim/ex-commands/quick-note.ex'
  h.createAlternativeFormatTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createTask()
  -- local directory = '/tmp/tasks'
  local directory = '/storage/docs/notes/tasks'
  local exCommandsFile = '/storage/src/dot_files/nvim/ex-commands/task.ex'
  h.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createZettel()
  -- local directory = '/tmp/zettelkasten/cards'
  local directory = '/storage/src/writeloop/fleeting-content/zettelkasten'
  local exCommandsFile = '/storage/src/dot_files/nvim/ex-commands/zettel.ex'
  h.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createFlashCard()
  -- local directory = '/tmp/flashcards'
  local directory = '/storage/src/writeloop/fleeting-content/flashcards'
  local exCommandsFile = '/storage/src/dot_files/nvim/ex-commands/flashcard.ex'
  h.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

return M
