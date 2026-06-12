local p = require("palette")

local M = {}

function M.resize_float(delta)
  if vim.bo.filetype ~= "toggleterm" then
    return
  end
  local win = vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.relative == "" then
    return
  end
  local _, term = require("toggleterm.terminal").identify()
  if not term then
    return
  end
  local new_w = math.max(40, cfg.width + delta)
  local new_h = math.max(10, cfg.height + delta)
  term.float_opts = term.float_opts or {}
  term.float_opts.width = new_w
  term.float_opts.height = new_h
  vim.api.nvim_win_set_config(win, vim.tbl_extend("force", cfg, {
    width = new_w,
    height = new_h,
    row = math.ceil(vim.o.lines - new_h) * 0.5 - 1,
    col = math.ceil(vim.o.columns - new_w) * 0.5 - 1,
  }))
end

require("toggleterm").setup {
  -- <C-\> alone is not mapped here; use <C-\>1 .. <C-\>9 in keymaps.lua so each digit is a separate terminal.
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,

  shade_terminals = true,
  shading_factor = 2,

  direction = "float",
  float_opts = {
    border = "rounded",
    width = math.floor(vim.o.columns * 0.85),
    height = math.floor(vim.o.lines * 0.8),
    winblend = 10,
  },

  highlights = {
    Normal = { guibg = p.bg2 },
    NormalFloat = { guibg = p.bg2 },
    FloatBorder = { guifg = p.border, guibg = p.bg2 },
  },

  on_open = function(term)
    vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
  end,
}

return M

