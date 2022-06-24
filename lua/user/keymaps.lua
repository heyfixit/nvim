local default_opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local key_lookup = {}

-- Shorten function name
-- options will use default_opts if not specified
local keymap = function(mode, key, action, description, options)
  options = default_opts or options
  options.desc = description
  key_lookup[key] = {
    action = action,
    description = description,
    mode = mode,
    options = options,
  }
  vim.keymap.set(mode, key, action, options)
end

local build_keymap_fn = function(mode, default_opts)
  return function(key, action, description, options)
    keymap(mode, key, action, description, default_opts)
  end
end

local normal_keymap = build_keymap_fn("n")

local insert_keymap = build_keymap_fn("i")

local visual_keymap = build_keymap_fn("v")

local visual_block_keymap = build_keymap_fn("x")

local terminal_keymap = build_keymap_fn("t", term_opts)

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", "Leader Key Stuff")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal Mode --
normal_keymap("<C-h>", "<C-w>h", "jump to left split")
normal_keymap("<C-j>", "<C-w>j", "jump to lower split")
normal_keymap("<C-k>", "<C-w>k", "jump to upper split")
normal_keymap("<C-l>", "<C-w>l", "jump to right split")

-- Resize with arrows
normal_keymap("<C-Up>", ":resize -2<CR>", "shrink current split vertically")
normal_keymap("<C-Down>", ":resize +2<CR>", "expand current split vertically")
normal_keymap("<C-Left>", ":vertical -2<CR>", "shrink current split horizontally")
normal_keymap("<C-Right>", ":vertical resize +2<CR>", "expand current split horizontally")

-- Navigate buffers
normal_keymap("<S-l>", ":bnext<CR>", "go to next buffer")
normal_keymap("<S-h>", ":bprev<CR>", "go to previous buffer")
normal_keymap("+", ":bnext<CR>", "go to next buffer")
normal_keymap("_", ":bprev<CR>", "go to previous buffer")

-- BBye buffer closing
-- Difference between delete and wipeout: delete keeps buffer in jump list so ctrl-o brings it back
-- Wipeout removes from jump list
normal_keymap(",c", "<cmd>Bdelete<cr>", "delete buffer")
normal_keymap(",C", "<cmd>Bwipeout<cr>", "delete buffer")

-- Insert Mode --
-- Press jk fast to Esc
insert_keymap("jk", "<ESC>", "jk fast in insert mode sends Escape")

-- Visual --
-- Stay in visual mode
visual_keymap("<", "<gv", "move a tab left but stay in visual mode")
visual_keymap(">", ">gv", "move a tab right but stay in visual mode")

-- Move text up and down
visual_keymap("<A-k>", ":m .-2<CR>==gv", "move selection down")
visual_keymap("<A-j>", ":m .+1<CR>==gv", "move selection up")
visual_keymap(
  "p",
  '"_dP',
  "paste over selection, keep pasted content in clipboard instead of overwriting it with selected content"
)

-- Visual Block --
-- Move text up and down
visual_block_keymap("J", ":move '>+1<CR>gv-gv", "move selected rows up")
visual_block_keymap("K", ":move '<-2<CR>gv-gv", "move selected rows down")
visual_block_keymap("<A-j>", ":move '>+1<CR>gv-gv", "move selected rows up")
visual_block_keymap("<A-k>", ":move '<-2<CR>gv-gv", "move selected rows down")

-- Terminal --
-- Better terminal navigation
terminal_keymap("<C-h>", "<C-\\><C-N><C-w>h", "jump to left split from terminal split")
terminal_keymap("<C-j>", "<C-\\><C-N><C-w>j", "jump to right split from terminal split")
terminal_keymap("<C-k>", "<C-\\><C-N><C-w>k", "jump to upper split from terminal split")
terminal_keymap("<C-l>", "<C-\\><C-N><C-w>l", "jump to lower split from terminal split")

-- Telescope
normal_keymap(
  "<leader>ff",
  "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
  "open file finder"
)
normal_keymap("<leader>fF", "<cmd>Telescope live_grep<cr>", "open live_grep")

-- Nvim Tree
normal_keymap("<f1>", "<cmd>NvimTreeToggle<cr>", "toggle NvimTree with f1")

-- Bufferline
normal_keymap("<leader>bp", "<cmd>BufferLinePick<cr>", "pick a buffer")

-- Neorg journal keys
normal_keymap("<leader>jt", "<cmd>Neorg journal today<cr>", "create a journal entry for today")
normal_keymap("<leader>jy", "<cmd>Neorg journal yesterday<cr>", "create a journal entry for yesterday")
normal_keymap("<leader>jm", "<cmd>Neorg journal tomorrow<cr>", "create a journal entry for tomorrow")

-- find files in nvim config dir
normal_keymap("<leader>fc", function()
  return require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
    previewer = false,
    cwd = "~/.config/nvim",
    prompt_title = "find neovim config files",
  }))
end, "open file finder for nvim configs")

-- find Neorg files
normal_keymap("<leader>fn", function()
  return require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
    previewer = false,
    cwd = "~/notes",
    prompt_title = "find Neorg config files",
  }))
end, "open file finder for Neorg configs")

-- live grep nvim config dir
normal_keymap("<leader>fC", function()
  return require("telescope.builtin").live_grep({
    shorten_path = false,
    cwd = "~/.config/nvim",
    search_dirs = { "~/.config/nvim" },
    prompt_title = "live grep nvim configs",
    hidden = false,
  })
end, "live grep vim config")

-- live grep Neorg files
normal_keymap("<leader>fN", function()
  return require("telescope.builtin").live_grep({
    shorten_path = false,
    cwd = "~/notes",
    search_dirs = { "~/notes" },
    prompt_title = "live grep neorg files",
    hidden = false,
  })
end, "live grep neorg files")

-- Format with \f
normal_keymap("\\f", "<cmd>Format<cr>", "Run LSP formatter")

-- Telescope projects with fp
normal_keymap("<leader>fp", "<cmd>Telescope projects<cr>", "Telescope recent projects")