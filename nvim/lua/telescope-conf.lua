require('telescope').load_extension('aerial')

require('telescope').setup({
  extensions = {
    aerial = {
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = true
    }
  }
})
