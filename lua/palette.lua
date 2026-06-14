local M = {}

local function blend_line(c, bg)
  return require("kanagawa.lib.color")(c):blend(bg, 0.92):to_hex()
end

function M.refresh()
  local ok, colors = pcall(require, "kanagawa.colors")
  if not ok then
    return
  end
  local resolved = colors.setup()
  local theme = resolved.theme
  local palette = resolved.palette
  M.bg0 = theme.ui.bg
  M.bg1 = theme.ui.bg_p1
  M.bg2 = theme.ui.bg_m3
  M.bg3 = theme.ui.bg_m1
  M.fg = theme.ui.fg
  M.fg_dim = theme.ui.fg_dim
  M.accent = palette.oniViolet
  M.accent_muted = palette.springBlue
  M.warn = theme.diag.warning
  M.err = theme.diag.error
  M.border = theme.ui.bg_p2
  M.visual = theme.ui.bg_p2
  M.search = theme.ui.bg_p2
  M.line_err = blend_line(theme.diag.error, theme.ui.bg)
  M.line_warn = blend_line(theme.diag.warning, theme.ui.bg)
  M.ibl_indent = palette.sumiInk4
  M.ibl_scope = palette.oniViolet
  M.rainbow = { palette.sakuraPink, palette.oniViolet, palette.springBlue }
end

M.refresh()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "kanagawa*",
  callback = function()
    M.refresh()
  end,
})

return M
