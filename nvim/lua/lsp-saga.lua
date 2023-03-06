local saga = require("lspsaga")

saga.setup({
  -- When there are possible code actions to be taken, a lightbulb icon will be shown
  ui = {
    -- This option only works in Neovim 0.9
    title = true,
    -- Border type can be single, double, rounded, solid, shadow.
    border = "single",
    winblend = 0,
    expand = "",
    collapse = "",
    code_action = "💡",
    incoming = " ",
    outgoing = " ",
    hover = ' ',
    kind = {},
  },
  lightbulb = {
    enable = false,
    enable_in_insert = false,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
	code_action_prompt = { -- due to errors when changing buffers. e.g. "Error executing vim.schedule lua callback: .../start/lspsaga.nvim/lua/lspsaga/codeaction/indicator.lua:37: line value outside range"
		enable = false,
	},
	error_sign = "E",
	warn_sign = "W",
	hint_sign = "H",
	infor_sign = "I",
	border_style = "round"
})
