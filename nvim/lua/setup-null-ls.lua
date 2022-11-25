-- buitin sources:
--   <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md>

-- Documentation on how to setup the builtin sources (formatters, linters, completion), like the ones below:
--   <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md>

-- How to configure "formatting on save":
--   <https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save>

local helpers = require("tiagoprn.helpers")

local project_root = vim.fn.getcwd()

local sources = {
	require("null-ls").builtins.diagnostics.pylint.with({
		condition = function(utils)
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition

			local filetype = vim.bo.filetype
			if filetype ~= "python" then
				return false
			end

			local skip_pylint_file = project_root .. "/" .. "skip-pylint"
			local skip_pylint_file_exists = helpers.get_file_exists(skip_pylint_file)
			if skip_pylint_file_exists == true then
				vim.notify("skip-pylint file found on project root, pylint will be disabled for this file.")
				return false
			else
				vim.notify("skip-pylint file NOT found on project root, so pylint will be enabled for this file.")
				return true
			end
		end,
		command = function()
			local default_venv = "~/.pyenv/versions/neovim"

			local current_venv = vim.env.VIRTUAL_ENV

			local venv = ""

			if current_venv then
				venv = current_venv
				vim.notify("Current VENV defined as " .. current_venv .. " ")
			else
				venv = default_venv
				vim.notify("Current VENV NOT defined, using default (" .. default_venv .. ") ")
			end

			local path = vim.fn.expand(venv .. "/bin/pylint")
			-- print("Current virtualenv is " .. venv)
			-- print("Current path is " .. path)

			return path
		end,
		extra_args = function()
			local pylintrc_file = ".pylintrc"
			local default_pylintrc = "/storage/src/devops/python/default_configs/.pylintrc"
			local project_root = vim.fn.getcwd()
			local pylintrc_full_path = project_root .. "/" .. pylintrc_file

			file_exists = helpers.get_file_exists(pylintrc_full_path)

			if file_exists == false then
				vim.notify("Could not find .pylintrc, using default one.")
				pylintrc_full_path = default_pylintrc
			end

			vim.notify("Using .pylintrc from: " .. pylintrc_full_path)

			return {
				"--rcfile",
				pylintrc_full_path,
				"--score",
				"no",
				"--msg-template",
				"{path}:{line}:{column}:{C}:{msg}",
			}
		end,
	}),
	require("null-ls").builtins.formatting.black.with({
		condition = function(utils)
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition

			local filetype = vim.bo.filetype
			if filetype ~= "python" then
				return false
			end

			local skip_black_file = project_root .. "/" .. "skip-black"
			local skip_black_file_exists = helpers.get_file_exists(skip_black_file)
			if skip_black_file_exists == true then
				vim.notify("skip-black file found on project root, black will be disabled for this file.")
				return false
			else
				vim.notify("skip-black file NOT found on project root, so black will be enabled for this file.")
				return true
			end
		end,
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
		condition = function(utils)
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition

			local filetype = vim.bo.filetype
			if filetype ~= "python" then
				return false
			end

			local skip_isort_file = project_root .. "/" .. "skip-isort"
			local skip_isort_file_exists = helpers.get_file_exists(skip_isort_file)
			if skip_isort_file_exists == true then
				vim.notify("skip-isort file found on project root, isort will be disabled for this file.")
				return false
			else
				vim.notify("skip-isort file NOT found on project root, so isort will be enabled for this file.")
				return true
			end
		end,
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
	require("null-ls").builtins.diagnostics.flake8.with({
		condition = function(utils)
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#condition

			local filetype = vim.bo.filetype
			if filetype ~= "python" then
				return false
			end

			local enable_flake8_file = project_root .. "/" .. "enable-flake8"
			local enable_flake8_file_exists = helpers.get_file_exists(enable_flake8_file)
			if enable_flake8_file_exists == true then
				vim.notify("enable-flake8 file found on project root, so flake8 will be enabled for this file.")
				return true
			else
				vim.notify("enable-flake8 file NOT found on project root, so flake8 will be disabled for this file.")
				return false
			end
		end,
		args = function()
			return { "--max-line-length", "160", "--format", "default", "--stdin-display-name", "$FILENAME", "-" }
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
					vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 20000 })
				end,
			})
		end
	end,
})
