require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,

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
  },

  default_component_configs = {
    diagnostics = {
      symbols = {
        error = " ",
        warn  = " ",
        info  = " ",
        hint  = "󰌶 ",
      },
    },
    git_status = {
      symbols = {
        added = "+",
        modified = "~",
        deleted = "x",
        renamed = "→",
        untracked = "?",
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

-- === Highlight overrides ===
vim.api.nvim_set_hl(0, "NeoTreeFileNameError", { fg = "#FF2A2A", bold = true })
vim.api.nvim_set_hl(0, "NeoTreeDirectoryNameError", { fg = "#FF4444", bold = true })
vim.api.nvim_set_hl(0, "NeoTreeDiagnosticError", { fg = "#FF2A2A", bold = true })

vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#FFA500", bold = true })
vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#00FF00", bold = true })
vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#FF0000", bold = true })

-- === Functions to manage highlights ===
local function update_error_highlights()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local diags = vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
    if #diags == 0 then
      -- no errors, clear highlights
      vim.api.nvim_set_hl(0, "NeoTreeFileNameError", {})
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryNameError", {})
      vim.api.nvim_set_hl(0, "NeoTreeDiagnosticError", {})
    else
      -- reapply highlights
      vim.api.nvim_set_hl(0, "NeoTreeFileNameError", { fg = "#FF2A2A", bold = true })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryNameError", { fg = "#FF4444", bold = true })
      vim.api.nvim_set_hl(0, "NeoTreeDiagnosticError", { fg = "#FF2A2A", bold = true })
    end
  end
end

-- === Auto-refresh Neo-tree on Git changes, diagnostics, or autosave ===
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "GitsignsUpdate",
  callback = function()
    pcall(require("neo-tree.command").execute, { action = "refresh" })
    update_error_highlights()
  end,
})

vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
  callback = function()
    update_error_highlights()
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    pcall(require("neo-tree.command").execute, { action = "refresh" })
    update_error_highlights()
  end,
})
