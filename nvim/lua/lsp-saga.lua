local saga = require("lspsaga")

saga.setup({
	code_action_prompt = { -- due to errors when changing buffers. e.g. "Error executing vim.schedule lua callback: .../start/lspsaga.nvim/lua/lspsaga/codeaction/indicator.lua:37: line value outside range"
		enable = false,
	},
	error_sign = "E",
	warn_sign = "W",
	hint_sign = "H",
	infor_sign = "I",
	border_style = "round",
})
