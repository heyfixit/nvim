local nta_status_ok, nta = pcall(require, "nvim-ts-autotag")
if not nta_status_ok then
  return
end

nta.setup()
