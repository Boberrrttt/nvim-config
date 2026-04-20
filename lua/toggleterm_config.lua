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
    Normal = { guibg = "#12171f" },
    NormalFloat = { guibg = "#12171f" },
    FloatBorder = { guifg = "#3EB489", guibg = "#12171f" },
  },

  on_open = function(term)
    vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
  end,
}

