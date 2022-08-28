local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
  print("failed to load neogen plugin")
  return
end

neogen.setup({})
