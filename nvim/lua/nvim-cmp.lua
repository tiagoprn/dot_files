-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  view = {
    entries = 'native'
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- ['<Tab>'] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   else
    --     fallback()
    --   end
    -- end,
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({
      config = {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'buffer' },
        }
      }
    }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  }
})
