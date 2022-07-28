require("nvim-tree").setup({
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "t", action = "tabnew" },
				{ key = "v", action = "vsplit" },
				{ key = "s", action = "split" },
			},
		},
	},
	filters = {
		custom = { ".git", "__pycache__", ".cache" },
	},
})
