local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  print("neorg failed to load!")
  return
end

neorg.setup({
  load = {
    ["core.defaults"] = {},
    ["core.integrations.telescope"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          home = "~/notes/home",
        },
      },
    },
    ["core.norg.concealer"] = {},
    ["core.norg.journal"] = {
      config = {
        workspace = "home",
        strategy = "flat",
      },
    },
    ["core.norg.qol.toc"] = {},
    ["core.export"] = {},
    ["core.export.markdown"] = {},
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
  },
})

-- Start neorg automatically
-- vim.cmd([[silent! NeorgStart silent=true]])
