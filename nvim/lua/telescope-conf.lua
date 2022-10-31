require("telescope").load_extension("aerial")

require("telescope").setup({
	defaults = {
		layout_config = {
			-- prompt_position = "top",
			width = 0.9,
			height = 0.9,
			preview_cutoff = 120,
			horizontal = { mirror = false },
			vertical = { mirror = false },
		},
	},
	-- pickers = {
	-- 	find_files = {
	-- 		theme = "dropdown",
	-- 	},
	-- 	live_grep = {
	-- 		theme = "dropdown",
	-- 	},
	-- },
	extensions = {
		fzf = {
			-- false will only do exact matching override the generic sorter
			-- override the file sorter or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		aerial = {
			-- Display symbols as <root>.<parent>.<symbol>
			show_nesting = true,
		},
	},
})

-- To get fzf loaded and working with telescope
require("telescope").load_extension("fzf")
-- get nvim-notify loaded and working with telescope
require("telescope").load_extension("notify")
