-- to check all available themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
-- MY FAVORITES: powerline_dark powerline papercolor_light solarized_light

local helpers = require("tiagoprn.helpers")

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "powerline",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true, -- enable global statusline (have a single statusline at bottom of neovim instead of one for every window).
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "diff" },
		lualine_z = { "branch" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
	winbar = {
		lualine_a = { "location" },
		lualine_b = { "progress" },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "filetype" },
		lualine_z = { "filename" },
	},
	inactive_winbar = {
		lualine_a = { helpers.current_window_number },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "location" },
		lualine_z = { "filename" },
	},
})
