-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, mind = pcall(require, "mind")
if not status_ok then
	return
end

-- here I can find more configuration from phaazon (this plugin's creator):
--    https://github.com/phaazon/config/blob/master/nvim/lua/pkg/mind.lua

mind.setup({
	keymaps = { -- useful inside the tree window
		normal = {
			["ms"] = "open_data_index",
		},
	},

	-- persistence = {
	-- 	state_path = "/storage/mind/",
	-- 	data_dir = "/storage/mind/data/",
	-- },
	--
	edit = {
		data_header = "# %s",
	},

	ui = {
		width = 50,
		icon_preset = {
			{ " ", "Sub-project" },
			{ " ", "Journal, newspaper, weekly and daily news" },
			{ " ", "For when you have an idea" },
			{ " ", "Note taking?" },
			{ "陼", "Task management" },
			{ " ", "Uncheck, empty square or backlog" },
			{ " ", "Full square or on-going" },
			{ " ", "Check or done" },
			{ " ", "Trash bin, deleted, cancelled, etc." },
			{ " ", "GitHub" },
			{ " ", "Monitoring" },
			{ " ", "Internet, Earth, everyone!" },
			{ " ", "Frozen, on-hold" },
		},
	},
})
