local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- Whenever the BufWritePost event happens within the plugins.lua file
-- we source plugins.lua and run PackerSync
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
-- pcall returns true for first value, then result of function as next one
-- Basically a safe require statement
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("requiring packer did not work, check plugins.lua")
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
-- Plugins live inside ~/.local/share/nvim it's where plugins keep all of their data
-- inside of site/pack/packer
-- plugins are just github repos
-- plugins that live in packer's start directory, they're not lazy-loaded
-- plugins that live in packer's opt directory are lazy loaded often based on vim events :help autocmd
-- PackerSync compiles a packer_compiled.lua file that is sometimes worth deleting if facing
-- weird plugin issues, should probably gitignore it
-- plugin repos usually have a doc directory which contains help docs
return packer.startup(function(use)
  -- My plugins here
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins

  -- Colorschemes
  use("lunarvim/colorschemes") -- A bunch of colorschemes to try out
  use("folke/tokyonight.nvim") -- fancy colorscheme

  -- cmp plugins
  use("hrsh7th/nvim-cmp") -- The completion plugin
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("saadparwaiz1/cmp_luasnip") -- snippet completions
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua") -- helpful when editing nvim config

  -- snippets
  use("L3MON4D3/LuaSnip") --snippet engine
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- LSP
  use("neovim/nvim-lspconfig") -- enable LSP
  use("williamboman/nvim-lsp-installer") -- simple to use language server installer

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-media-files.nvim")

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("nvim-treesitter/playground")

  -- Auto closing parens and brackets
  use("windwp/nvim-autopairs")

  -- Easy commenting
  use("numToStr/Comment.nvim")
  -- Context-aware commenting for more complex DSLs and such like TSX files
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- Git stuff
  use("lewis6991/gitsigns.nvim")

  -- Dev icons
  use("kyazdani42/nvim-web-devicons")

  -- Nvim Tree / File Explorer
  use("kyazdani42/nvim-tree.lua")

  -- Buffer Control
  use("akinsho/bufferline.nvim")
  use("moll/vim-bbye")

  -- Making non-lsp things speak lsp language
  use("jose-elias-alvarez/null-ls.nvim")

  -- Diff lines with Linediff, reset with LinediffReset
  use("andrewradev/linediff.vim")

  -- Status Line
  use("nvim-lualine/lualine.nvim")

  -- Terminal Stuffs
  use("akinsho/toggleterm.nvim")

  -- Project management
  use("ahmedkhalf/project.nvim")

  -- Faster LUA loading
  use("lewis6991/impatient.nvim")

  -- Adds indentation guides to all lines
  use("lukas-reineke/indent-blankline.nvim")

  -- Fancy startup screen
  use("goolord/alpha-nvim")

  -- Harpoon
  use("ThePrimeagen/harpoon")

  -- Fancy Drawer Showing LSP stuff
  use("folke/trouble.nvim")

  -- Symbol Outline
  use("simrat39/symbols-outline.nvim")

  -- Neorg note taking
  use("vhyrro/neorg-telescope")
  use("nvim-neorg/neorg")

  -- ThePrimeagen's Refactoring
  -- use("ThePrimeagen/refactoring.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
