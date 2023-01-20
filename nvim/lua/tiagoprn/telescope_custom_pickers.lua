local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

-- find_files: git_log on selected file

local function run_git_log_on_selection(prompt_bufnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		vim.cmd([[!git log ]] .. selection[1])
	end)
	return true
end

M.git_log = function()
	-- example for running a command on a file
	local opts = {
		attach_mappings = run_git_log_on_selection,
	}
	require("telescope.builtin").find_files(opts)
end

-- buffers: switch to buffer using :drop

local function run_drop_on_selection(prompt_bufnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		-- print(vim.inspect(selection))
		local selected_file = selection["filename"]
		local vim_command = ":drop " .. selected_file
		vim.cmd(vim_command)
		vim.notify("Switched to window with buffer -> " .. vim_command)
	end)
	return true
end

M.switch_to_buffer = function()
	-- example for running a command on a file
	local opts = {
		show_all_buffers = false,
		ignore_current_buffer = true,
		attach_mappings = run_drop_on_selection,
	}
	require("telescope.builtin").buffers(opts)
end

return M
