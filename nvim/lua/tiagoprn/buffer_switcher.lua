---------------------------------------------------------------
-- Open the list of buffers (that are on windows) and switch to one of them
---------------------------------------------------------------

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local switch_to_window = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "switch_to_window",
			finder = finders.new_table({
				results = { "red", "green", "blue" },
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)

					-- get the selection with action_state.
					-- To get current prompt input, you would use:
					--    action_state.get_current_line()
					local selection = action_state.get_selected_entry()

					-- print(vim.inspect(selection))

					-- put the text in the current buffer
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

switch_to_window(require("telescope.themes").get_dropdown({}))
