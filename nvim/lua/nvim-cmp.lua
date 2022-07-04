-- Setup nvim-cmp.
local cmp = require("cmp")

cmp.setup({
	view = {
		entries = "native",
	},
	snippet = {
		expand = function(args)
			vim.fn["snippy#anonymous"](args.body)
		end,
	},
	mapping = {
		-- navigate up on selected function/method docs:
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		-- navigate down on selected function/method docs:
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({
			config = {
				sources = {
					{ name = "nvim_lsp" },
					{ name = "snippy" },
					{ name = "buffer" },
				},
			},
		}),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
})
