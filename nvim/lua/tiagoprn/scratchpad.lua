local command = vim.api.nvim_command

local h = require("tiagoprn.helpers")

local M = {}

function M.createFleetingNote()
	-- local directory = '/tmp/fleeting-notes'
	local directory = "/storage/docs/fleeting-notes"
	local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/fleeting-note.ex"
	h.createAlternativeFormatTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createTask()
	-- local directory = '/tmp/tasks'
	local directory = "/storage/docs/notes/tasks"
	local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/task.ex"
	h.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createFlashCard()
	-- local directory = '/tmp/flashcards'
	local directory = "/storage/src/writeloop-raw/content/posts"
	local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/flashcard.ex"
	h.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

return M
