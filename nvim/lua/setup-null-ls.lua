require("null-ls").setup({
    sources = {
        -- require("null-ls").builtins.formatting.stylua,
        -- require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell,
        require("null-ls").builtins.formatting.black.with({
          extra_args = {
            "-S", "-t", "py37", "-l", "79", "--quiet", "-"
          }
        }),
        require("null-ls").builtins.formatting.isort.with({
          extra_args = {
            "-m", "3", "--trailing-comma", "--use-parentheses", "--honor-noqa", "--quiet", "-"
          }
        }),
        require("null-ls").builtins.diagnostics.pylint.with({
          extra_args = {
            "--rcfile", ".pylintrc", "--output-format", "text", "--score", "no",
            "--msg-template", "{path}:{line}:{column}:{C}:{msg}", "${INPUT}"
          }
        }),
        require("null-ls").builtins.diagnostics.shellcheck.with({
          extra_args = {
            "-f", "gcc", "-x"
          }
        }),
        require("null-ls").builtins.formatting.shfmt.with({
          extra_args = {
            "-ci", "-s", "-bn"
          }
        }),
    },
    diagnostics_format = "[#{c}] #{m} (#{s})"
})
