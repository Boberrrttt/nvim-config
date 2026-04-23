-- UI chrome (options, lualine, bufferline, ibl). Colors: dracula/vim via plugins.lua.

vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.pumblend = 8
vim.opt.fillchars = {
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  verthoriz = "┼",
  fold = " ",
  eob = " ",
}
vim.opt.listchars = { tab = "› ", trail = "·", extends = "…", precedes = "…" }
vim.opt.showtabline = 2
vim.opt.mousemoveevent = true

local p = require("palette")

-- ibl v3 uses Ibl* groups (dracula has no built-in ibl v3 hl names).
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#44475a", nocombine = true })
vim.api.nvim_set_hl(0, "IblWhitespace", { link = "IblIndent" })
vim.api.nvim_set_hl(0, "IblScope", { fg = p.accent, bold = true })

-- rainbow-delimiters.nvim (Dracula: pink / purple / cyan)
local rd_cycle = { "#ff79c6", "#bd93f9", "#8be9fd" }
local rd_groups = {
  "RainbowDelimiterRed",
  "RainbowDelimiterYellow",
  "RainbowDelimiterBlue",
  "RainbowDelimiterOrange",
  "RainbowDelimiterGreen",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
}
for i, name in ipairs(rd_groups) do
  vim.api.nvim_set_hl(0, name, { fg = rd_cycle[((i - 1) % #rd_cycle) + 1] })
end

-- lualine defaults: refresh on BufWritePost etc. But LSP diagnostics and gitsigns
-- `diff` stats update *after* save, asynchronously — so we also refresh on
-- DiagnosticChanged and User GitSignsUpdate (see autocommands below). The
-- lualine `filename` component does not color by diagnostic severity; bufferline
-- does for tab colors; lualine section B shows error/warn counts.
require("lualine").setup({
  options = {
    theme = "dracula",
    globalstatus = true,
    icons_enabled = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "neo-tree", "neo-tree-popup" } },
    -- Must list full `events` when setting refresh (lualine merges this table, but
    -- `events` is a full replacement on merge — include defaults from lualine
    -- config + DiagnosticChanged for async LSP publish after :w / autosave).
    refresh = {
      events = {
        "WinEnter",
        "BufEnter",
        "BufWritePost",
        "SessionLoadPost",
        "FileChangedShellPost",
        "VimResized",
        "Filetype",
        "CursorMoved",
        "CursorMovedI",
        "ModeChanged",
        "DiagnosticChanged",
      },
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      {
        "diff",
        colored = true,
        symbols = { added = "󰐕 ", modified = "󰏫 ", removed = "󰍵 " },
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = { error = "󰅙 ", warn = "󰀪 ", info = "󰋽 ", hint = "󰌶 " },
        colored = true,
        always_visible = true,
      },
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = { modified = " ○", readonly = " ", unnamed = "[No Name]" },
      },
    },
    lualine_x = {
      {
        "filetype",
        icons_enabled = true,
        colored = true,
      },
    },
    lualine_y = { "encoding", "fileformat" },
    lualine_z = { "progress", "location" },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})

local bufferline = require("bufferline")
bufferline.setup({
  options = {
    mode = "buffers",
    style_preset = bufferline.style_preset.default,
    themable = true,
    numbers = "none",
    separator_style = "thin",
    diagnostics = "nvim_lsp",
    diagnostics_update_on_event = true,
    offsets = {
      {
        filetype = "neo-tree",
        text = "Explorer",
        text_align = "center",
        separator = true,
        highlight = { fg = p.accent, bg = p.bg2, bold = true },
      },
    },
    hover = { enabled = true, delay = 150, reveal = { "close" } },
    always_show_bufferline = true,
  },
})

-- After autosave, git status and LSP can finish a moment later; lualine/bufferline
-- were only redrawing on CursorMoved/BufWritePost, so chrome looked stale.
vim.api.nvim_create_augroup("ChromeAfterAsync", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "ChromeAfterAsync",
  pattern = "GitSignsUpdate",
  callback = function()
    vim.schedule(function()
      require("lualine").refresh({ kind = "window", place = { "statusline" }, trigger = "autocmd" })
      vim.cmd.redrawtabline()
    end)
  end,
})
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = "ChromeAfterAsync",
  callback = function()
    vim.schedule(function()
      vim.cmd.redrawtabline()
    end)
  end,
})

require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
    highlight = "IblIndent",
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
    highlight = "IblScope",
  },
  exclude = {
    filetypes = {
      "help",
      "lazy",
      "neo-tree",
      "neo-tree-popup",
      "TelescopePrompt",
      "toggleterm",
      "undotree",
    },
  },
})
