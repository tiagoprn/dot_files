require("aerial").setup({
  keymaps = {
    ["o"] = false, -- original "actions.tree_toggle"
    ["O"] = false, -- original "actions.tree_toggle_recursive",
    ["t"] = "actions.tree_toggle",
    ["T"] = "actions.tree_toggle_recursive",
    ["<C-v>"] = "actions.jump_vsplit",
    ["<C-s>"] = false, -- original "actions.jump_split"
    ["<C-x>"] = "actions.jump_split",
    ["zR"] = false, -- original "actions.tree_open_all"
    ["("] = "actions.tree_open_all",
    ["zM"] = false, -- original "actions.tree_close_all"
    [")"] = "actions.tree_close_all",
  },
})
