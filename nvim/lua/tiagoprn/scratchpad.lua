local helpers = require("tiagoprn.helpers")

local M = {}

function M.createFleetingNote()
  -- local directory = '/tmp/fleeting-notes'
  local directory = "/storage/docs/fleeting-notes"
  local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/fleeting-note.ex"
  helpers.createAlternativeFormatTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createTask()
  -- local directory = '/tmp/tasks'
  local directory = "/storage/docs/tasks"
  local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/task.ex"
  helpers.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createFlashCard()
  -- local directory = '/tmp/flashcards'
  local directory = "/storage/src/writeloop-raw/content/posts"
  local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/flashcard.ex"
  helpers.createTimestampedFileWithSnippet(directory, exCommandsFile)
end

function M.createPost()
  -- local directory = '/tmp/posts'
  local directory = "/storage/src/writeloop-raw/content/posts"
  local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/post.ex"

  local post_name = vim.fn.input("Enter a name for the post: ")
  local slug = require("tiagoprn.helpers").slugify(post_name)

  helpers.createSluggedFileWithSnippet(directory, exCommandsFile, slug, post_name)
end

function M.updateFleetingNotesCategories()
  local current_buffer_path = vim.api.nvim_buf_get_name(0)
  local path_list = helpers.string_split(current_buffer_path, "/")
  local search_list = { "storage", "fleeting-notes" }
  local found_on_list = helpers.search_on_list(path_list, search_list)

  if #found_on_list == 2 then
    vim.api.nvim_command(":UpdateFleetingNotesCategories")
    vim.notify("Fleeting notes categories file updated.")
  end
end

return M
