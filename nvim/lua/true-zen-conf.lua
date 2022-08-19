-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, true_zen = pcall(require, "true-zen")
if not status_ok then
	return
end

true_zen.setup({
	modes = { -- configurations per mode
		ataraxis = {
			minimum_writing_area = { -- minimum size of main window
				width = 90,
				height = 44,
			},
			padding = { -- padding windows
				left = 20,
				right = 20,
				top = 0,
				bottom = 0,
			},
		},
		minimalist = {
			ignored_buf_types = { "nofile" }, -- save current options from any window except ones displaying these kinds of buffers
			options = { -- options to be disabled when entering Minimalist mode
				number = false,
				relativenumber = false,
				showtabline = 0,
				signcolumn = "no",
				statusline = "",
				cmdheight = 1,
				laststatus = 0,
				showcmd = false,
				showmode = false,
				ruler = false,
				numberwidth = 1,
			},
		},
		narrow = {
			folds_style = "informative",
			run_ataraxis = true, -- display narrowed text in a Ataraxis session
		},
	},
	integrations = {
		tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
		kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
			enabled = false,
			font = "+3",
		},
		twilight = true, -- enable twilight (ataraxis)
		lualine = true, -- hide nvim-lualine (ataraxis)
	},
})
