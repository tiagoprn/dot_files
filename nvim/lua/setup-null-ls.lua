-- buitin sources:
--   <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md>

-- Documentation on how to setup the builtin sources (formatters, linters, completion), like the ones below:
--   <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md>

-- How to configure "formatting on save":
--   <https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save>

local sources = {
	-- require("null-ls").builtins.completion.spell,
	require("null-ls").builtins.diagnostics.pylint.with({
		command = function()
			local default_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/pylint")
			return default_path
		end,
		extra_args = function()
			return {
				"--rcfile",
				".pylintrc",
				"--score",
				"no",
				"--msg-template",
				"{path}:{line}:{column}:{C}:{msg}",
			}
		end,
	}),
	require("null-ls").builtins.formatting.black.with({
		command = function()
			local default_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/black")
			return default_path
		end,
		args = function()
			return { "--quiet", "-" }
		end,
		extra_args = function()
			return { "--line-length", "79", "--skip-string-normalization" }
		end,
	}),
	require("null-ls").builtins.formatting.isort.with({
		command = function()
			local default_path = vim.fn.expand("~/.pyenv/versions/neovim/bin/isort")
			return default_path
		end,
		args = function()
			return { "--quiet", "-" }
		end,
		extra_args = function()
			return { "-m", "3", "--trailing-comma", "--use-parentheses", "honor-noqa" }
		end,
	}),
	require("null-ls").builtins.diagnostics.shellcheck.with({
		command = "shellcheck",
		extra_args = { "-f", "gcc", "-x" },
	}),
	require("null-ls").builtins.formatting.shfmt.with({
		command = "shfmt",
		extra_args = { "-ci", "-s", "-bn", "-i", "4" },
	}),
	require("null-ls").builtins.formatting.stylua,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

require("null-ls").setup({
	sources = sources,
	debug = false, -- "false" when finished debugging, "true" to inspect logs
	diagnostics_format = "[#{c}] #{m} (#{s})",

	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 10000 })
				end,
			})
		end
	end,
})
