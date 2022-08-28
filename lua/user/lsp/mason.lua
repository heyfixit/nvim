local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  print("mason failed to load")
  return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  print("mason-lspconfig failed to laod")
  return
end

local servers = {
  "cssls",
  "cssmodules_ls",
  "emmet_ls",
  "html",
  "jdtls",
  "jsonls",
  "sumneko_lua",
  "tflint",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "clangd",
  "rust_analyzer",
  "taplo",
  "lemminx"
}

local DEFAULT_SETTINGS = {
    ui = {
        -- Whether to automatically check for new versions when opening the :Mason window.
        check_outdated_packages_on_open = true,

        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "none",

        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },

        keymaps = {
            -- Keymap to expand a package
            toggle_package_expand = "<CR>",
            -- Keymap to install the package under the current cursor position
            install_package = "i",
            -- Keymap to reinstall/update the package under the current cursor position
            update_package = "u",
            -- Keymap to check for new version for the package under the current cursor position
            check_package_version = "c",
            -- Keymap to update all installed packages
            update_all_packages = "U",
            -- Keymap to check which installed packages are outdated
            check_outdated_packages = "C",
            -- Keymap to uninstall a package
            uninstall_package = "X",
            -- Keymap to cancel a package installation
            cancel_installation = "<C-c>",
            -- Keymap to apply language filter
            apply_language_filter = "<C-f>",
        },
    },

    -- The directory in which to install packages.
    install_root_dir = vim.fn.stdpath("data") .. "/mason",

    pip = {
        -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
        -- and is not recommended.
        --
        -- Example: { "--proxy", "https://proxyserver" }
        install_args = {},
    },

    -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
    -- debugging issues with package installations.
    log_level = vim.log.levels.INFO,

    -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
    -- packages that are requested to be installed will be put in a queue.
    max_concurrent_installers = 4,

    github = {
        -- The template URL to use when downloading assets from GitHub.
        -- The placeholders are the following (in order):
        -- 1. The repository (e.g. "rust-lang/rust-analyzer")
        -- 2. The release version (e.g. "v0.3.0")
        -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
        download_url_template = "https://github.com/%s/releases/download/%s/%s",
    },
}

mason.setup(DEFAULT_SETTINGS)
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

-- Register a handler that will be called for all installed servers
-- Alternatively, you may also register handlers on specific server instances
for _, server_name in pairs(servers) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities
  }

  if server_name == "jsonls" then
    local jsonls_opts = require("user.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server_name == "sumneko_lua" then
    local sumneko_opts = require("user.lsp.settings.sumneko_lua")
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server_name == "tsserver" then
    local tsserver_opts = require "user.lsp.settings.tsserver"
    opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
  end

  if server_name == "emmet_ls" then
    local emmet_ls_opts = require "user.lsp.settings.emmet_ls"
    opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
  end

  if server_name == "rust_analyzer" then
    local keymap = vim.keymap.set
    local key_opts = { silent = true }

    keymap("n", "<leader>rh", "<cmd>RustSetInlayHints<Cr>", key_opts)
    keymap("n", "<leader>rhd", "<cmd>RustDisableInlayHints<Cr>", key_opts)
    keymap("n", "<leader>th", "<cmd>RustToggleInlayHints<Cr>", key_opts)
    keymap("n", "<leader>rr", "<cmd>RustRunnables<Cr>", key_opts)
    keymap("n", "<leader>rem", "<cmd>RustExpandMacro<Cr>", key_opts)
    keymap("n", "<leader>roc", "<cmd>RustOpenCargo<Cr>", key_opts)
    keymap("n", "<leader>rpm", "<cmd>RustParentModule<Cr>", key_opts)
    keymap("n", "<leader>rjl", "<cmd>RustJoinLines<Cr>", key_opts)
    keymap("n", "<leader>rha", "<cmd>RustHoverActions<Cr>", key_opts)
    keymap("n", "<leader>rhr", "<cmd>RustHoverRange<Cr>", key_opts)
    keymap("n", "<leader>rmd", "<cmd>RustMoveItemDown<Cr>", key_opts)
    keymap("n", "<leader>rmu", "<cmd>RustMoveItemUp<Cr>", key_opts)
    keymap("n", "<leader>rsb", "<cmd>RustStartStandaloneServerForBuffer<Cr>", key_opts)
    keymap("n", "<leader>rd", "<cmd>RustDebuggables<Cr>", key_opts)
    keymap("n", "<leader>rv", "<cmd>RustViewCrateGraph<Cr>", key_opts)
    keymap("n", "<leader>rw", "<cmd>RustReloadWorkspace<Cr>", key_opts)
    keymap("n", "<leader>rss", "<cmd>RustSSR<Cr>", key_opts)
    keymap("n", "<leader>rxd", "<cmd>RustOpenExternalDocs<Cr>", key_opts)

    require("rust-tools").setup {
      tools = {
        on_initialized = function()
          vim.cmd [[
            autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
          ]]
        end,
      },
      server = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
        settings = {
          ["rust-analyzer"] = {
            lens = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
    }

    goto continue
  end
  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  lspconfig[server_name].setup(opts)
  ::continue::
end
