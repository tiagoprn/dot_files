-- Setup nvim-cmp.
local cmp = require("cmp")
local snippy = require("snippy")

cmp.setup({
	view = {
		entries = "native",
	},
	window = {
		documentation = cmp.config.window.bordered(),
		completion = cmp.config.window.bordered(),
	},
	snippet = {
		expand = function(args)
			vim.fn["snippy#anonymous"](args.body)
		end,
	},
	mapping = {
		-- navigate up on selected function/method docs:
		["<C-k>"] = cmp.mapping.scroll_docs(-4),
		-- navigate down on selected function/method docs:
		["<C-j>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({
			config = {
				sources = {
					{ name = "nvim_lsp" },
					{ name = "snippy" },
					{ name = "buffer" },
					{
						name = "path",
						option = {
							trailing_slash = true,
						},
					},
          { name = 'nvim_lsp_signature_help' },
				},
			},
		}),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				})
			elseif snippy.can_expand_or_advance() then
				snippy.expand_or_advance()
			-- elseif has_words_before() then
			--     cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				})
			elseif snippy.can_jump(-1) then
				snippy.previous()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
})
