local snippy = require("snippy")

snippy.setup({
	mappings = {
		i = {
			["<Tab>"] = "expand_or_advance",
			["<S-Tab>"] = "previous",
		},
	},
})
