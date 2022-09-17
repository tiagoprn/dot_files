-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
--
-- ideas to more advanced harpoons: https://github.com/anuvyklack/hydra.nvim/wiki
--
local status_ok, Hydra = pcall(require, "hydra")
if not status_ok then
	return
end

local harpoon_hint = [[
^ ^ _1_: open harpoon file 1    _n_: go to next harpoon file             ^ ^
^ ^ _2_: open harpoon file 2    _p_: go to prev harpoon file             ^ ^
^ ^ _3_: open harpoon file 3    _t_: go to below tmux pane               ^ ^
^ ^ _4_: open harpoon file 4    _c_: run command on below tmux pane      ^ ^
^ ^ _5_: open harpoon file 5    _m_: run make command (through easypick) ^ ^
^ ^ _6_: open harpoon file 6                                             ^ ^
^ ^ _7_: open harpoon file 7                                             ^ ^
^ ^ _8_: open harpoon file 8                                             ^ ^
^ ^ _9_: open harpoon file 9                                             ^ ^
^ ^                             _<Esc>_: quit                            ^ ^
]]

Hydra({
	name = "harpoon",
	hint = harpoon_hint,
	config = {
		color = "pink",
		invoke_on_body = true,
		hint = {
			border = "rounded",
		},
	},
	mode = "n",
	body = "<leader>h",
	heads = {
		{ "1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>" },
		{ "2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>" },
		{ "3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>" },
		{ "4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>" },
		{ "5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>" },
		{ "6", "<cmd>lua require('harpoon.ui').nav_file(6)<CR>" },
		{ "7", "<cmd>lua require('harpoon.ui').nav_file(7)<CR>" },
		{ "8", "<cmd>lua require('harpoon.ui').nav_file(8)<CR>" },
		{ "9", "<cmd>lua require('harpoon.ui').nav_file(9)<CR>" },
		{ "n", "<cmd>lua require('harpoon.ui').nav_next()<CR>" },
		{ "p", "<cmd>lua require('harpoon.ui').nav_prev()<CR>" },
		{ "t", "<cmd>lua require('harpoon.tmux').gotoTerminal('{down-of}')<CR>" },
		{ "c", "<cmd>lua require('harpoon.tmux').sendCommand('{down-of}', vim.fn.input('Enter the command: '))<CR>" },
		{ "m", ":Easypick make<CR>" },
		{ "<Esc>", nil, { exit = true } },
	},
})
