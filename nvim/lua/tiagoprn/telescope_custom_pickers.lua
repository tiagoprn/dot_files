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

local function load_buffer_without_window_action(prompt_bufnr, map)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		-- print(vim.inspect(selection))

		local selected_file = selection["filename"]

		local bufnr = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_name(bufnr, selected_file)
		vim.api.nvim_buf_call(bufnr, vim.cmd.edit)

		vim.notify("Opened buffer '" .. selected_file .. "' without a window.")
	end)
	return true
end

M.load_buffer_without_window = function()
	-- example for running a command on a file
	local opts = {
		prompt_title = "Open file/buffer without opening a window",
		attach_mappings = load_buffer_without_window_action,
	}
	require("telescope.builtin").find_files(opts)
end

M.search_on_open_files = function()
	-- example for running a command on a file
	local opts = {
		prompt_title = "Search on open files",
		grep_open_files = true,
	}
	require("telescope.builtin").live_grep(opts)
end

return M
