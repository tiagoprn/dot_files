local M = {}  -- creates a new table here to isolate from the global scope

function M.openZettel()
  require('telescope.builtin').git_files {
    prompt_title = "\ Find Zettel /",
    cwd = "/storage/docs/notes/zettelkasten/cards",
  }
end

function M.openQuickNotes()
  require('telescope.builtin').git_files {
    prompt_title = "\\ Find QuickNote /",
    cwd = "/storage/docs/notes/quick",
  }
end

function M.openTaskCard()
  require('telescope.builtin').git_files {
    prompt_title = "\\ Find Task Card /",
    cwd = "/storage/docs/notes/tasks",
  }
end

function M.openPersonalDoc()
  require('telescope.builtin').git_files {
    prompt_title = "\\ Find Personal Doc /",
    cwd = "/storage/docs/notes/personal",
  }
end

function M.openWorkDoc()
  require('telescope.builtin').git_files {
    prompt_title = "\\ Find Work Doc /",
    cwd = "/storage/docs/notes/work",
  }
end

return M
