local job = require("plenary.job")
local zen_mode = require("zen-mode")
local helpers = require("tiagoprn.helpers")
local ts_utils = require("nvim-treesitter.ts_utils")
local treesitter = require("vim.treesitter")

local M = {}

function M.shout(str)
	return (string.upper(str) .. "!")
end

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

	vim.ui.input({
		prompt = "Enter a name for the post: ",
		-- "telescope" below is to force using dressing.nvim
		telescope = require("telescope.themes").get_cursor(),
	}, function(post_name)
		if post_name then
			local slug = require("tiagoprn.helpers").slugify(post_name)
			helpers.createSluggedFileWithSnippet(directory, exCommandsFile, slug, post_name)
		end
	end)
end

function M.createZettel()
	-- local directory = '/tmp/zettels'
	local directory = "/storage/src/writeloop-raw/PERSONAL/zettelkasten"
	local exCommandsFile = "/storage/src/dot_files/nvim/ex-commands/zettel.ex"

	vim.ui.input({
		prompt = "Enter a name for the zettel: ",
		-- "telescope" below is to force using dressing.nvim
		telescope = require("telescope.themes").get_cursor(),
	}, function(zettel_name)
		if zettel_name then
			local slug = require("tiagoprn.helpers").slugify(zettel_name)
			helpers.createSluggedFileWithSnippet(directory, exCommandsFile, slug, zettel_name)
		end
	end)
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

function M.gitSyncFleetingNotes()
	local current_buffer_path = vim.api.nvim_buf_get_name(0)
	local path_list = helpers.string_split(current_buffer_path, "/")
	local search_list = { "storage", "fleeting-notes" }
	local found_on_list = helpers.search_on_list(path_list, search_list)

	if #found_on_list == 2 then
		job:new({
			command = "git-auto-sync",
			args = { "sync" },
			on_exit = function(j, exit_code)
				-- local debug = ""
				-- for k, v in pairs(j:result()) do
				-- 	print(k)
				-- 	vim.notify("key: " .. k)
				-- 	debug = debug .. v
				-- end

				if exit_code ~= 0 then
					vim.notify("Error git syncing repository. Try git pull --rebase manually on the repo.")
				end
				-- vim.api.nvim_command(":e!")
				vim.notify("Git synced repository. RELOAD THE FILE MANUALLY with <C-e>.")
			end,
		}):start(1000, 1)
	end
end

function M.zenCode()
	zen_mode.toggle({
		window = {
			width = 200,
			options = {
				signcolumn = "yes",
				number = true,
				relativenumber = true,
				cursorline = true,
				cursorcolumn = true,
				list = false,
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = true,
				showcmd = false,
			},
			twilight = { enabled = false },
			gitsigns = { enabled = true },
			tmux = { enabled = false },
		},
	})
end

function M.zenWrite()
	zen_mode.toggle({
		window = {
			backdrop = 1,
			width = 200,
			options = {
				signcolumn = "no",
				number = false,
				relativenumber = false,
				cursorline = false,
				cursorcolumn = false,
				list = false,
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = true,
				showcmd = true,
			},
			twilight = { enabled = false },
			gitsigns = { enabled = true },
			tmux = { enabled = false },
		},
	})
end

function M.embed_value_from_python_printable_expression()
	-- runs an expression through python, so that the result can be embedded on the current buffer with nvim's "read" command

	vim.ui.input({
		prompt = "Type a python expression that can be printed: (e.g.: '100 - (8*3)')",
		-- "telescope" below is to force using dressing.nvim
		telescope = require("telescope.themes").get_cursor(),
	}, function(expression)
		if expression then
			local command = "read !python3 -c 'value = " .. expression .. "; print(value)'"
			vim.cmd(command)
			vim.notify("Successfully computed expression: '" .. expression .. "'")
		end
	end)
end

function M.run_python_script_on_current_line()
	-- runs a python script on the current line, so that the result can be embedded on the current buffer with nvim's "read" command
	-- E.g. on how to use the prompt:
	-- /storage/src/dot_files/nvim/python/line-processors/split_tags.py line=

	vim.ui.input({
		prompt = "Path to python script to run on the current line (with the argument):",
		-- "telescope" below is to force using dressing.nvim
		telescope = require("telescope.themes").get_cursor(),
	}, function(full_script_path_with_arg)
		local current_line = vim.api.nvim_get_current_line()
		if full_script_path_with_arg then
			local command = "read !python3 " .. full_script_path_with_arg .. "'" .. current_line .. "'"
			vim.cmd(command)
			vim.notify("Successfully computed script.")
		end
	end)
end

---
function M.get_current_function_name()
	-- https://www.reddit.com/r/neovim/comments/nnru7r/how_do_i_get_the_name_of_the_current_function_i/
	-- https://alpha2phi.medium.com/neovim-101-tree-sitter-d8c5a714cb03
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then
		return ""
	end

	local expr = current_node

	while expr do
		if expr:type() == "function_definition" then
			break
		end
		expr = expr:parent()
	end

	if not expr then
		return ""
	end

	local function_name = (ts_utils.get_node_text(expr:child(1)))[1]

	local class_name = (ts_utils.get_node_text(expr:parent():parent()))[1]
	print(vim.inspect(class_name))

	-- local debug = "function: " .. function_name .. ", other: " .. class_name
	-- vim.notify(debug)

	-- local filename = vim.fn.expand("%:t")
	-- local absolute_filepath = vim.fn.expand("%:p")
	-- local relative_filepath = vim.fn.expand("%:.")

	local path = function_name .. "." .. class_name
	vim.notify(path)

	return path
end

return M
