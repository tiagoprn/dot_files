-- to check all available themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
-- MY FAVORITES: powerline_dark powerline papercolor_light solarized_light

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "powerline_dark",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true, -- enable global statusline (have a single statusline at bottom of neovim instead of one for every window).
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { "filename" },
		lualine_x = {
			{ "diagnostics", sources = { "nvim_lsp" }, always_visible = true },
			"filetype",
		},
		lualine_y = { "location" },
		lualine_z = { "progress" },
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
})
