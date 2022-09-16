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
local base_branch = "develop"

-- a list of commands that you want to pick from
local list = [[
<< EOF
:PackerInstall
:Telescope find_files
:Git blame
EOF
]]

-- TODO: Add custom pickers here.
-- TODO: add a picker to select commands from Makefile and pass it through run with harpoon on tmux pane below
local custom_pickers = {
	-- list files inside current folder with default previewer
	{
		-- name for the custom picker, that can be invoked using :Easypick <name> (supports tab completion)
		name = "ls",
		-- the command to execute, output has to be a list of plain text entries
		command = "ls",
		-- specify your custom previwer, or use one of the easypick.previewers
		previewer = easypick.previewers.default(),
	},

	-- diff current branch with base_branch and show files that changed with respective diffs in preview
	{
		name = "changed_files",
		command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
		previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
	},

	-- list files that have conflicts with diffs in preview
	{
		name = "conflicts",
		command = "git diff --name-only --diff-filter=U --relative",
		previewer = easypick.previewers.file_diff(),
	},

	-- create a command palette
	{
		name = "command_palette",
		command = "cat " .. list,
		-- pass a pre-configured action that runs the command
		action = easypick.actions.run_nvim_command,
		-- you can specify any theme you want, but the dropdown looks good for this example =)
		opts = require("telescope.themes").get_dropdown({}),
	},
}

easypick.setup({ pickers = custom_pickers })
