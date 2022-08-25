require("telescope").load_extension("aerial")

require("telescope").setup({
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
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- more opts here
			}),
		},
	},
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
-- get ui-select loaded and working with telescope
require("telescope").load_extension("ui-select")
-- get nvim-notify loaded and working with telescope
require("telescope").load_extension("notify")
