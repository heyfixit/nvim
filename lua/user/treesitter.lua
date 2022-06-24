local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  print("nvim-treesitter failed to load!")
  return
end

configs.setup({
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages asynchronously (only applies to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of languages that will be disabled
    additional_vim_regex_highlighting = true,
  },

  -- enable autopairs magic
  autopairs = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false, -- ??? look at context_commentstring repo
    },
  },
})
