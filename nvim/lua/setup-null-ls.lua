-- Documentation on how to setup the builtin sources (formatters, linters, completion), like the ones below:
--   <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md>

local sources = {
  -- require("null-ls").builtins.completion.spell,
  require("null-ls").builtins.diagnostics.pylint.with({
    command = vim.fn.expand("~/.pyenv/versions/neovim/bin/pylint"),
    extra_args = { "--rcfile", ".pylintrc", "--score", "no", "--msg-template", "{path}:{line}:{column}:{C}:{msg}" }
  }),
  require("null-ls").builtins.formatting.black.with({
    command = vim.fn.expand("~/.pyenv/versions/neovim/bin/black"),
    args = { "--quiet", "-" },
    extra_args = { "--line-length", "79", "--skip-string-normalization" },
  }),
  require("null-ls").builtins.formatting.isort.with({
    command = vim.fn.expand("~/.pyenv/versions/neovim/bin/isort"),
    args = { "--quiet", "-" },
    extra_args = { "-m", "3", "--trailing-comma", "--use-parentheses", "honor-noqa" }
    }),
  require("null-ls").builtins.diagnostics.shellcheck.with({
    command = "shellcheck",
    extra_args = { "-f", "gcc", "-x" }
  }),
  require("null-ls").builtins.formatting.shfmt.with({
    command = "shfmt",
    extra_args = { "-ci", "-s", "-bn", "-i", "4" },
  }),
}

local null_ls = require("null-ls")

null_ls.setup({
  sources = sources,
  debug = true, -- "false" when finished debugging, "true" to inspect logs
  diagnostics_format = "[#{c}] #{m} (#{s})",
  on_attach = function(client)
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 2000 })")
    -- if client.server_capabilities.document_formatting then
    --   vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 2000 })")
    -- end
  end
})
