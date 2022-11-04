require("lsp_signature").setup({
  bind = true,
  floating_window_above_cur_line = true,
  toggle_key = "<leader>ls",
  handler_opts = {
    border = "rounded",
  },
})
