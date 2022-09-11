local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = true,
  sources = {
    -- Disabled for now, until it plays nicely with plain javascript and eslint language server
    -- code_actions.refactoring,
    formatting.prettierd,
    diagnostics.markdownlint,
    diagnostics.misspell,
    diagnostics.write_good,
    diagnostics.shellcheck,
    formatting.shfmt,
    formatting.black.with({ extra_args = { "--fast" } }),
    -- formatting.yapf,
    formatting.stylua,
    diagnostics.flake8,
    formatting.rustfmt
  },
})
