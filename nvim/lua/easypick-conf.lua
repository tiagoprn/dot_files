-- This is plugin is useful so that I can create my custom telescope pickers.
-- Examples: https://github.com/axkirillov/easypick.nvim/wiki

-- How to use:
-- :Easypick <name> (press <Tab> to cycle through available pickers)

-- This allows nvim to not crash if this plugin is not installed.
local status_ok, easypick = pcall(require, "easypick")
if not status_ok then
	return
end

-- only required for the example to work
-- local base_branch = "develop"

-- a list of commands that you want to pick from
-- local list = [[
-- << EOF
-- :PackerInstall
-- :Telescope find_files
-- :Git blame
-- EOF
-- ]]

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local harpoon_tmux = require("harpoon.tmux")

-- Customized based on https://github.com/axkirillov/easypick.nvim/blob/main/lua/easypick/actions.lua
local function harpoon_tmux_run_make(prompt_bufnr, _)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		local command = "make -s " .. selection[1]
		harpoon_tmux.sendCommand("{down-of}", command)
	end)
	return true
end

-- Add custom pickers here.
local custom_pickers = {
	-- list files inside current folder with default previewer
	-- {
	-- 	name = "ls",
	-- 	command = "ls",
	-- 	previewer = easypick.previewers.default(),
	-- },

	-- diff current branch with base_branch and show files that changed with respective diffs in preview
	-- {
	-- 	name = "changed_files",
	-- 	command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
	-- 	previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
	-- },

	-- list files that have conflicts with diffs in preview
	-- {
	-- 	name = "conflicts",
	-- 	command = "git diff --name-only --diff-filter=U --relative",
	-- 	previewer = easypick.previewers.file_diff(),
	-- },

	-- create a command palette
	-- {
	-- 	name = "command_palette_sample",
	-- 	command = "cat " .. list,
	-- 	action = easypick.actions.run_nvim_command,
	-- 	opts = require("telescope.themes").get_dropdown({}),
	-- },
	{
		name = "make",
		command = "make -s |ansi2txt | awk {'print $1'}",
		action = harpoon_tmux_run_make,
		opts = require("telescope.themes").get_dropdown({}),
	},
}

easypick.setup({ pickers = custom_pickers })
