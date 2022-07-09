-- use markdown syntax
vim.g["vimwiki_list"] = {{
  path = '~/vimwiki',
  syntax = 'markdown',
  ext = '.md'
}}

-- when following links, create markdown files
vim.g.vimwiki_markdown_link_ext = 1

vim.g.taskwiki_markup_syntax = 'markdown'
