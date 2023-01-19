---------------------------------------------------------------
-- To test this while you are developing, run the command below in normal mode:
--    :luafile %
--
-- For more details/advanced functionality:
--    <https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#guide-to-your-first-picker>
---------------------------------------------------------------

-- main module which is used to create a new picker.
local pickers = require("telescope.pickers")

-- provides interfaces to fill the picker with items.
local finders = require("telescope.finders")

-- "values" table which holds the user's configuration. So to make it easier we access this table directly in "conf".
local conf = require("telescope.config").values

-- "actions": holds all actions that can be mapped by a user. We also need it to access the default action so we can replace it. Also see ":help telescope.actions"
local actions = require("telescope.actions")

-- "action_state": gives us a few utility functions we can use to get the current picker, current selection or current line. Also see :help telescope.actions.state
local action_state = require("telescope.actions.state")

-- sample picker function: colors
-- "opts": the user can change how telescope behaves by passing in their own opts table when calling colors.
local colors = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "colors",
			-- "finder" is a required field that needs to be set to the result of a `finders` function. In this case we take "new_table" which allows us to define a static set of values, "results", which is an array of elements, in this case our colors as strings. It doesn't have to be an array of strings, it can also be an array of tables.
			finder = finders.new_table({
				results = { "red", "green", "blue" },
			}),
			-- "sorter": good practice to define it, because the default value will set it to empty(), meaning no sorter is attached and you can't filter the results. Good practice is to set the sorter to either conf.generic_sorter(opts) or conf.file_sorter(opts).
			sorter = conf.generic_sorter(opts),
			-- define the default action (what will be done when selecting an item from the finder)
			--    "prompt_bufnr" is the buffer number of the prompt buffer, which we can use to get the pickers object
			--    "map" is a function we can use to map actions or functions to arbitrary key sequences.
			attach_mappings = function(prompt_bufnr, map)
				-- replaces "select_default" (the default action), which is mapped to <CR> by default.
				-- To do this we need to call actions.select_default:replace and pass in a new function.
				actions.select_default:replace(function()
					-- close the picker with actions.close
					actions.close(prompt_bufnr)

					-- get the selection with action_state.
					-- To get current prompt input, you would use:
					--    action_state.get_current_line()
					local selection = action_state.get_selected_entry()

					-- print(vim.inspect(selection))

					-- put the text in the current buffer
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				-- this is to make sure the function always returns something, otherwise an error will be thrown.
				return true
			end,
		})
		-- "find": starts the picker
		:find()
end

-- open the picker, with the "dropdown" theme (what is passed as param to the function is the "opts" we defined above)
colors(require("telescope.themes").get_dropdown({}))
