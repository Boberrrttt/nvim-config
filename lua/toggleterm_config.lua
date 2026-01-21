require("toggleterm").setup {
  open_mapping = [[<c-\>]],
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
    Normal = { guibg = "#1e1e2e" },
    NormalFloat = { guibg = "#1e1e2e" },
    FloatBorder = { guifg = "#89b4fa", guibg = "#1e1e2e" },
  },

  on_open = function(term)
    vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
  end,
}

