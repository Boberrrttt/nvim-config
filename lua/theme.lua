-- IDE-style chrome: layered surfaces, one accent, consistent floats/popups.
-- Keymaps and editor behavior live elsewhere; this file is highlights + light `vim.opt` for visuals only.

local palette = {
  bg0 = "#0a0e14", -- editor
  bg1 = "#0f1419", -- cursor line / row
  bg2 = "#12171f", -- panels, inactive chrome
  bg3 = "#1a222d", -- borders, separators
  fg = "#c9d1d9",
  fg_dim = "#8b949e",
  accent = "#3EB489",
  accent_muted = "#2a8f6a",
  warn = "#e3b341",
  err = "#f85149",
  info = "#79c0ff",
  border = "#30363d",
  visual = "#1f3d2f",
  search = "#3a4750",
}

local p = palette

vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- global statusline (IDE-style)
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
vim.opt.showtabline = 2 -- always show buffer tab bar
vim.opt.mousemoveevent = true -- bufferline hover (e.g. reveal close icon)

-- Core UI (no `hi clear` — preserves LSP diagnostic highlights from lsp.lua)
vim.api.nvim_set_hl(0, "Normal", { bg = p.bg0, fg = p.fg })
vim.api.nvim_set_hl(0, "NormalNC", { bg = p.bg0, fg = p.fg_dim })
vim.api.nvim_set_hl(0, "CursorLine", { bg = p.bg1 })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = p.accent, bg = p.bg1, bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = p.accent_muted, bg = p.bg0 })
vim.api.nvim_set_hl(0, "SignColumn", { bg = p.bg0 })
vim.api.nvim_set_hl(0, "FoldColumn", { fg = p.fg_dim, bg = p.bg0 })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = p.bg2 })
vim.api.nvim_set_hl(0, "Visual", { bg = p.visual, fg = p.fg })
vim.api.nvim_set_hl(0, "VisualNC", { link = "Visual" })
vim.api.nvim_set_hl(0, "Search", { bg = p.search, fg = p.fg })
vim.api.nvim_set_hl(0, "IncSearch", { bg = p.accent, fg = p.bg0, bold = true })
vim.api.nvim_set_hl(0, "MatchParen", { bg = p.bg3, fg = p.accent, bold = true })
vim.api.nvim_set_hl(0, "Whitespace", { fg = p.bg3 })

-- Splits & floating (popups, LSP floats, lazy, which-key)
vim.api.nvim_set_hl(0, "WinSeparator", { fg = p.border, bg = p.bg0 })
vim.api.nvim_set_hl(0, "VertSplit", { link = "WinSeparator" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = p.bg2, fg = p.fg })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = p.border, bg = p.bg2 })
vim.api.nvim_set_hl(0, "FloatTitle", { fg = p.accent, bg = p.bg2, bold = true })

-- Cmd line / messages
vim.api.nvim_set_hl(0, "MsgArea", { bg = p.bg0, fg = p.fg })
vim.api.nvim_set_hl(0, "ModeMsg", { fg = p.accent, bold = true })
vim.api.nvim_set_hl(0, "MoreMsg", { fg = p.info })
vim.api.nvim_set_hl(0, "ErrorMsg", { fg = p.err })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = p.warn })

-- Completion menu
vim.api.nvim_set_hl(0, "Pmenu", { bg = p.bg2, fg = p.fg })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = p.bg3, fg = p.accent, bold = true })
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = p.bg0 })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = p.border })
vim.api.nvim_set_hl(0, "WildMenu", { link = "PmenuSel" })

-- Tab line (when used)
vim.api.nvim_set_hl(0, "TabLine", { bg = p.bg2, fg = p.fg_dim })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = p.bg0 })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = p.bg3, fg = p.accent, bold = true })

-- Fallback syntax (treesitter often links here)
vim.api.nvim_set_hl(0, "Comment", { fg = p.accent_muted, bg = p.bg0, italic = true })
vim.api.nvim_set_hl(0, "String", { fg = p.accent, bg = p.bg0 })
vim.api.nvim_set_hl(0, "Keyword", { fg = p.fg, bg = p.bg0, bold = true })
vim.api.nvim_set_hl(0, "Function", { fg = p.accent, bg = p.bg0, bold = true })
vim.api.nvim_set_hl(0, "Operator", { fg = p.fg, bg = p.bg0 })
vim.api.nvim_set_hl(0, "Constant", { fg = p.accent, bg = p.bg0, bold = true })
vim.api.nvim_set_hl(0, "Type", { fg = p.fg, bg = p.bg0, bold = true })
vim.api.nvim_set_hl(0, "Identifier", { fg = p.accent, bg = p.bg0 })

-- Oil.nvim
vim.api.nvim_set_hl(0, "OilDir", { fg = p.accent, bg = p.bg0, bold = true })
vim.api.nvim_set_hl(0, "OilFile", { fg = p.fg, bg = p.bg0 })
vim.api.nvim_set_hl(0, "OilLink", { fg = p.accent, bg = p.bg0, italic = true })
vim.api.nvim_set_hl(0, "OilSocket", { fg = p.accent, bg = p.bg0, bold = true })
vim.api.nvim_set_hl(0, "OilSplit", { bg = p.bg0 })

-- Telescope
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = p.bg2, fg = p.fg })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = p.border, bg = p.bg2 })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = p.accent, bg = p.bg2, bold = true })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = p.bg2, fg = p.fg })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = p.border, bg = p.bg2 })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = p.bg0, bg = p.accent, bold = true })
vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = p.accent, bg = p.bg2 })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = p.bg3, fg = p.accent })
vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = p.accent, bg = p.bg3 })
vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { bg = p.visual, fg = p.fg })

-- nvim-cmp kinds
vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = p.fg })
vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = p.fg_dim, strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = p.accent, bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = p.accent_muted, bold = true })
vim.api.nvim_set_hl(0, "CmpItemKind", { fg = p.info })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = p.fg_dim })

-- Gitsigns
vim.api.nvim_set_hl(0, "GitsignsAdd", { fg = p.accent })
vim.api.nvim_set_hl(0, "GitsignsChange", { fg = p.warn })
vim.api.nvim_set_hl(0, "GitsignsDelete", { fg = p.err })
vim.api.nvim_set_hl(0, "GitsignsAddNr", { link = "GitsignsAdd" })
vim.api.nvim_set_hl(0, "GitsignsChangeNr", { link = "GitsignsChange" })
vim.api.nvim_set_hl(0, "GitsignsDeleteNr", { link = "GitsignsDelete" })

-- LSP diagnostics (inline + signs — explicit so never invisible on dark bg)
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = p.err })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = p.warn })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = p.info })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = p.fg_dim })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = p.err, bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = p.warn, bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = p.info, bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = p.fg_dim, bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = p.err, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = p.warn, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = p.info, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = p.fg_dim, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = p.err })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = p.warn })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = p.info })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = p.fg_dim })

-- Indent guides (ibl)
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#21262d", nocombine = true })
vim.api.nvim_set_hl(0, "IblWhitespace", { link = "IblIndent" })
vim.api.nvim_set_hl(0, "IblScope", { fg = p.accent_muted, bold = true })

-- Treesitter: align with palette where links help
local ts_links = {
  ["@comment"] = "Comment",
  ["@comment.documentation"] = "Comment",
  ["@keyword"] = "Keyword",
  ["@keyword.function"] = "Keyword",
  ["@keyword.return"] = "Keyword",
  ["@function"] = "Function",
  ["@function.call"] = "Function",
  ["@method"] = "Function",
  ["@variable"] = "Identifier",
  ["@variable.parameter"] = "Identifier",
  ["@string"] = "String",
  ["@number"] = "Constant",
  ["@type"] = "Type",
  ["@type.builtin"] = "Type",
}
for group, target in pairs(ts_links) do
  vim.api.nvim_set_hl(0, group, { link = target })
end

-- Lualine theme (matches palette; global status bar)
local lualine_theme = {
  normal = {
    a = { bg = p.accent, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg3, fg = p.fg },
    c = { bg = p.bg2, fg = p.fg_dim },
  },
  insert = {
    a = { bg = p.info, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg3, fg = p.fg },
    c = { bg = p.bg2, fg = p.fg_dim },
  },
  visual = {
    a = { bg = p.warn, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg3, fg = p.fg },
    c = { bg = p.bg2, fg = p.fg_dim },
  },
  replace = {
    a = { bg = p.err, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg3, fg = p.fg },
    c = { bg = p.bg2, fg = p.fg_dim },
  },
  command = {
    a = { bg = p.accent_muted, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg3, fg = p.fg },
    c = { bg = p.bg2, fg = p.fg_dim },
  },
  inactive = {
    a = { bg = p.bg2, fg = p.fg_dim, gui = "bold" },
    b = { bg = p.bg2, fg = p.fg_dim },
    c = { bg = p.bg0, fg = p.fg_dim },
  },
}

require("lualine").setup({
  options = {
    theme = lualine_theme,
    globalstatus = true,
    icons_enabled = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "neo-tree", "neo-tree-popup" } },
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
    lualine_z = {    },
  },
})

-- Buffer line (tabs): matches palette; Neo-tree offset; no keymaps added here
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
  highlights = {
    fill = { bg = p.bg2 },
    background = { bg = p.bg2 },
    tab = { fg = p.fg_dim, bg = p.bg2 },
    tab_selected = { fg = p.accent, bg = p.bg0, bold = true },
    tab_close = { fg = p.fg_dim, bg = p.bg2 },
    tab_separator = { fg = p.bg2, bg = p.bg2 },
    tab_separator_selected = { fg = p.bg2, bg = p.bg0 },
    buffer = { fg = p.fg_dim, bg = p.bg2 },
    buffer_visible = { fg = p.fg, bg = p.bg3 },
    buffer_selected = { fg = p.fg, bg = p.bg0, bold = true },
    close_button = { fg = p.fg_dim, bg = p.bg2 },
    close_button_visible = { fg = p.fg_dim, bg = p.bg3 },
    close_button_selected = { fg = p.fg_dim, bg = p.bg0 },
    numbers = { fg = p.fg_dim, bg = p.bg2 },
    numbers_visible = { fg = p.fg_dim, bg = p.bg3 },
    numbers_selected = { fg = p.accent_muted, bg = p.bg0 },
    indicator_selected = { fg = p.accent, bg = p.bg0 },
    indicator_visible = { fg = p.bg3, bg = p.bg3 },
    separator = { fg = p.bg2, bg = p.bg2 },
    separator_visible = { fg = p.bg2, bg = p.bg3 },
    separator_selected = { fg = p.bg2, bg = p.bg0 },
    duplicate = { fg = p.fg_dim, bg = p.bg2, italic = true },
    duplicate_visible = { fg = p.fg_dim, bg = p.bg3, italic = true },
    duplicate_selected = { fg = p.fg_dim, bg = p.bg0, italic = true },
    modified = { fg = p.warn, bg = p.bg2 },
    modified_visible = { fg = p.warn, bg = p.bg3 },
    modified_selected = { fg = p.warn, bg = p.bg0 },
    trunc_marker = { fg = p.fg_dim, bg = p.bg2 },
    offset_separator = { fg = p.border, bg = p.bg2 },
  },
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
    },
  },
})
