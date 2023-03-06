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
		lualine_b = { helpers.show_macro_recording },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "diff" },
		lualine_z = { "branch" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
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
		lualine_z = { helpers.get_current_file_relative_path },
	},
	inactive_winbar = {
		lualine_a = { helpers.current_window_number },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "location" },
		lualine_z = { helpers.get_current_file_relative_path },
	},
})

-- Below is to refresh the status line when entering and leaving
-- the macro recording events.
-- reference: https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?utm_source=share&utm_medium=web2x&context=3

vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		require("lualine").refresh({
			place = { "statusline" },
		})
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		-- This is going to seem really weird!
		-- Instead of just calling refresh we need to wait a moment because of the nature of
		-- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
		-- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
		-- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
		-- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
		local timer = vim.loop.new_timer()
		timer:start(
			50,
			0,
			vim.schedule_wrap(function()
				require("lualine").refresh({
					place = { "statusline" },
				})
			end)
		)
	end,
})
