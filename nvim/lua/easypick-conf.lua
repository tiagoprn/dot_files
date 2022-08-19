-- This is plugin is useful so that I can create my custom telescope pickers.

-- This allows nvim to not crash if this plugin is not installed.
local status_ok, easypick = pcall(require, "easypick")
if not status_ok then
	return
end

-- only required for the example to work
local base_branch = "develop"

-- TODO: Add custom pickers here.
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
}

easypick.setup({ pickers = custom_pickers })
