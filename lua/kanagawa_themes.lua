local M = {}

function M.load(name)
  vim.o.background = name == "lotus" and "light" or "dark"
  require("kanagawa").load(name)
end

return M
