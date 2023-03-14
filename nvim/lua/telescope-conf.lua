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
	pickers = {
		find_files = {
			theme = "dropdown",
		},
		live_grep = {
			theme = "dropdown",
		},
	},
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
				-- even more opts
			}),

			-- pseudo code / specification for writing custom displays, like the one
			-- for "codeactions"
			-- specific_opts = {
			--   [kind] = {
			--     make_indexed = function(items) -> indexed_items, width,
			--     make_displayer = function(widths) -> displayer
			--     make_display = function(displayer) -> function(e)
			--     make_ordinal = function(e) -> string
			--   },
			--   -- for example to disable the custom builtin "codeactions" display
			--      do the following
			--   codeactions = false,
			-- }
		},
	},
})

-- To get fzf loaded and working with telescope
require("telescope").load_extension("fzf")

-- get nvim-notify loaded and working with telescope
require("telescope").load_extension("notify")

-- To get ui-select loaded and working with telescope
require("telescope").load_extension("ui-select")
