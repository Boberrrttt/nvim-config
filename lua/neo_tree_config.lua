local neo_tree_components = require("neo-tree.sources.common.components")
local neo_tree_utils = require("neo-tree.utils")

-- Must run *after* neo-tree's own highlights.setup() (called inside setup()), or git/diag colors get overwritten.
-- On ColorScheme, neo-tree re-runs highlights.setup; we schedule so our defs win.
local function apply_neo_tree_highlights()
  local p = require("palette")
  -- Git: restrained palette (accent family + warn/err only)
  vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = p.accent_muted, bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = p.warn, bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = p.err, bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeGitRenamed", { fg = p.accent, bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = p.accent_muted, italic = true })
  vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = p.fg_dim })
  vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = p.warn, bold = true, italic = true })
  vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = p.accent_muted })
  vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = p.warn })
  vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = p.fg })

  -- LSP diagnostics (custom name component + diagnostics column)
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = p.err })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = p.warn })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = p.fg_dim })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = p.fg_dim })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = p.err })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = p.warn })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = p.fg_dim })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = p.fg_dim })

  -- Neo-tree filename colors when diagnostics exist
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticError", { fg = p.err, bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticWarn", { fg = p.warn, bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticInfo", { fg = p.fg_dim })
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticHint", { fg = p.fg_dim })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(apply_neo_tree_highlights)
  end,
})

local function refresh_neo_tree()
  pcall(require("neo-tree.command").execute, { action = "refresh" })
end

-- Filename: git-colored by default; when diagnostics exist, tint the name with worst severity.
local function name_with_diagnostics(config, node, state)
  local result = neo_tree_components.name(config, node, state)
  local lookup = state.diagnostics_lookup
  if lookup and result then
    local diag = neo_tree_utils.index_by_path(lookup, node:get_id())
    if diag and diag.severity_string then
      result.highlight = "NeoTreeDiagnostic" .. diag.severity_string
    end
  end
  return result
end

require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  use_libuv_file_watcher = true,
  sources = { "filesystem", "buffers", "git_status" },

  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    group_empty_dirs = true,
    components = {
      name = name_with_diagnostics,
    },
  },

  default_component_configs = {
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      default = "",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      use_filtered_colors = true,
      highlight = "NeoTreeFileName",
    },
    diagnostics = {
      symbols = {
        error = " ",
        warn = " ",
        info = " ",
        hint = "󰌶 ",
      },
      highlights = {
        error = "DiagnosticSignError",
        warn = "DiagnosticSignWarn",
        info = "DiagnosticSignInfo",
        hint = "DiagnosticSignHint",
      },
    },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "",
        renamed = "➜",
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },

  window = {
    width = 32,
    mappings = {
      ["o"] = "open",
      ["<space>"] = "toggle_node",
      ["C"] = "close_node",
      ["R"] = "refresh",
    },
  },
})

-- Apply once at startup after the event loop settles (theme may load after this file)
vim.schedule(apply_neo_tree_highlights)

vim.api.nvim_create_autocmd("DiagnosticChanged", { callback = refresh_neo_tree })
vim.api.nvim_create_autocmd("BufWritePost", { callback = refresh_neo_tree })
vim.api.nvim_create_autocmd("User", {
  pattern = "GitsignsUpdate",
  callback = refresh_neo_tree,
})

-- Pick up git changes made outside Neovim (terminal, other tools)
vim.api.nvim_create_autocmd("FocusGained", { callback = refresh_neo_tree })

-- Startup: only file tree + editor (no auto-session restore). Show tree on the left, focus stays in code buffer.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if vim.g.started_by_firenvim or vim.g.vscode then
      return
    end
    vim.schedule(function()
      pcall(require("neo-tree.command").execute, {
        action = "show",
        position = "left",
        source = "filesystem",
      })
    end)
  end,
})
