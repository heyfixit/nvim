-- This line alone would cause startup failures if tokyonight plugin
-- was not installed
-- vim.cmd "colorscheme tokyonight"

-- Instead, we do this:
local colorscheme = "tokyonight"

-- here we're doing a protected call to run the vim command, that way we catch
-- exceptions and can print an error, but continue as normal
-- we do this because we don't want lack of a plugin to cause config loading exception
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found! (missing plugin?")
  return
end
