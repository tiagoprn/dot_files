-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
	return
end

harpoon.setup({
	menu = {
		width = vim.api.nvim_win_get_width(0) - 4,
	},
	global_settings = {
		-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
		save_on_toggle = false,

		-- saves the harpoon file upon every change. disabling is unrecommended.
		save_on_change = true,

		-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
		enter_on_sendcmd = true,

		-- closes any tmux windows harpoon that harpoon creates when you close Neovim.
		tmux_autoclose_windows = false,

		-- filetypes that you want to prevent from adding to the harpoon list menu.
		excluded_filetypes = { "harpoon" },

		-- set marks specific to each git branch inside git repository
		mark_branch = true,
	},
	projects = {
		-- Yes $HOME works
		-- ["$HOME/personal/vim-with-me/server"] = {
		-- 	term = {
		-- 		cmds = {
		-- 			"./env && npx ts-node src/index.ts",
		-- 		},
		-- 	},
		-- },
		["/storage/src/writeloop-raw"] = {
			term = {
				cmds = {
					"make dev-server",
					"make build",
				},
			},
		},
	},
})
