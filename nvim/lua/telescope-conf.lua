require('telescope').load_extension('aerial')

require('telescope').setup({
  extensions = {
    aerial = {
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = true
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- more opts here
      }
    }
  }
})

-- get ui-select loaded and working with telescope
require("telescope").load_extension("ui-select")
