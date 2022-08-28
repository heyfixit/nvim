local status_ok, dap = pcall(require, "dap")
if not status_ok then
  print("failed to load dap plugin")
  return
end

local dapui_status_ok, dapui = pcall(require, "dapui")
if not dapui_status_ok then
  print("failed to load dapui plugin")
  return
end

-- Set some dap event listeners to open and close dapui
dap.listeners.after.event_terminated["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
