-- To more advanced package configuration: https://github.com/wbthomason/packer.nvim#quickstart
-- (on this link there also information on how to install lua rocks (packages))

return require("packer").startup(function(use)
	-- Packer can manage itself
	use({ "wbthomason/packer.nvim" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
	})

	-- It sets vim.ui.select to telescope. That means for example that neovim core stuff can fill the telescope picker.
	-- Example would be lua vim.lsp.buf.code_action().
	use({ "nvim-telescope/telescope-ui-select.nvim" })

	-- useful to create custom telescope pickers
	use({ "axkirillov/easypick.nvim", requires = "nvim-telescope/telescope.nvim" })

	use({ "tpope/vim-surround" })

	-- snippets
	use({ "dcampos/nvim-snippy" })

	-- macros persistance
	use({ "chamindra/marvim" })

	-- color schemes
	-- the one below support the treesitter markdown plugin with its highlight group colors:
	-- https://www.reddit.com/r/neovim/comments/rg97j4/treesitter_for_markdown/hoktehq/?utm_medium=android_app&utm_source=share&context=3
	use({
		"catppuccin/nvim",
		as = "catppuccin",
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- markdown syntax highlighting
	use({
		"plasticboy/vim-markdown",
		requires = { "godlygeek/tabular" },
	})
	--
	-- float term (floating terminal)
	use({ "akinsho/toggleterm.nvim" })

	-- vim-notify
	use({ "rcarriga/nvim-notify" })

	-- A tree project view
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Beautiful and customizable indentation
	use({ "Yggdroot/indentLine" })

	-- Comment
	use({ "numToStr/Comment.nvim" })

	-- show contents of vim registers on a sidebar
	use({ "junegunn/vim-peekaboo" })

	-- better movement
	use({ "phaazon/hop.nvim" })

	-- auto pairs
	use({ "windwp/nvim-autopairs" })

	-- session manager
	use({ "Shatur/neovim-session-manager" })

	-- gitsigns
	use({ "lewis6991/gitsigns.nvim" })

	-- navigation (to integrate better with tmux)
	use({ "christoomey/vim-tmux-navigator" })

	-- support for hugo template language (go)
	use({ "fatih/vim-go" })

	-- highlight colors
	use({ "brenoprata10/nvim-highlight-colors" })

	-- pretty list for showing diagnostics, references, telescope results, quickfix and location lists
	use({ "folke/trouble.nvim" })

	-- zen mode (allows zooming on a buffer, between other functionality)
	use({ "Pocco81/true-zen.nvim" })

	-- # LANGUAGE SERVERS - begin

	-- --  handles automatically launching and initializing language servers installed on your system
	use({ "neovim/nvim-lspconfig" })

	-- -- nice UIs for LSP functions
	-- unsupported
	-- use {'glepnir/lspsaga.nvim'}
	-- supported fork from above
	use({ "tami5/lspsaga.nvim" })

	use({ "jose-elias-alvarez/null-ls.nvim" })

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	use({ "nvim-treesitter/nvim-treesitter-context" })

	-- -- enable LSP completion
	use({
		"hrsh7th/nvim-cmp",
		requires = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "dcampos/cmp-snippy" },
	})

	-- -- lsp signatures when hovering over methods
	use({ "ray-x/lsp_signature.nvim" })

	-- cmp source to complete filesystem paths
	use({ "/hrsh7th/cmp-path" })

	-- code navigation through classes, methods and functions
	use({ "stevearc/aerial.nvim" })

	-- Automatically creates missing LSP diagnostics highlight groups for
	-- color schemes that don't yet support the Neovim 0.5 builtin lsp client
	use({ "folke/lsp-colors.nvim" })

	-- -- lua development environment
	use({ "folke/lua-dev.nvim" })

	-- -- -- repl
	use({ "rafcamlet/nvim-luapad" })

	-- # LANGUAGE SERVERS - end
end)
