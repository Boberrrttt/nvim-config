-- ========================================
-- Neovim 0.11+: use vim.lsp.config + vim.lsp.enable (merges nvim-lspconfig's lsp/*.lua).
-- Manual vim.lsp.start() in FileType bypasses that pipeline and often fails to attach or publish diagnostics.
-- ========================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local palette = require("palette")

-- npm global CLIs on Windows (adjust if you use a different Node/npm layout)
local ts_ls_cmd = {
  "cmd.exe",
  "/c",
  "C:\\Users\\robert\\AppData\\Roaming\\npm\\typescript-language-server.cmd",
  "--stdio",
}
local pyright_cmd = {
  "cmd.exe",
  "/c",
  "C:\\Users\\robert\\AppData\\Roaming\\npm\\pyright-langserver.cmd",
  "--stdio",
}

-- =====================
-- Diagnostics
-- =====================
local diag_config = {
  virtual_text = {
    spacing = 2,
    source = true,
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(diag_config)

-- Default capabilities for every enabled server
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Per-server overrides (merged with nvim-lspconfig's lsp/ts_ls.lua, lsp/pyright.lua, lsp/lua_ls.lua)
vim.lsp.config("ts_ls", {
  cmd = ts_ls_cmd,
})

local venv = os.getenv("VIRTUAL_ENV")
local python_path = venv and (venv .. "\\Scripts\\python.exe") or "python"

vim.lsp.config("pyright", {
  cmd = pyright_cmd,
  settings = {
    python = {
      pythonPath = python_path,
    },
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = { globals = { "vim" } },
    },
  },
})

vim.lsp.enable("ts_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("lua_ls")

-- Keymaps + per-client diagnostic namespace (Nvim 0.11 LSP namespaces)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local ns = vim.lsp.diagnostic.get_namespace(client.id)
    if ns then
      vim.diagnostic.config(diag_config, ns)
    end

    local bufnr = args.buf
    if vim.b[bufnr]._my_lsp_maps then
      return
    end
    vim.b[bufnr]._my_lsp_maps = true

    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

function CopyLineDiagnostics()
  local bufnr = 0
  local lnum = vim.fn.line(".") - 1
  local diags = vim.diagnostic.get(bufnr, { lnum = lnum })

  if #diags == 0 then
    print("No diagnostics on this line")
    return
  end

  local messages = {}
  for _, d in ipairs(diags) do
    table.insert(messages, d.message)
  end

  vim.fn.setreg("+", table.concat(messages, "\n"))
  print("Diagnostics copied to clipboard!")
end

vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = palette.line_err })
vim.api.nvim_set_hl(0, "DiagnosticLineWarn", { bg = palette.line_warn })

vim.fn.sign_define("DiagnosticSignError", {
  text = "✘",
  texthl = "DiagnosticSignError",
  linehl = "DiagnosticLineError",
  numhl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
  text = "▲",
  texthl = "DiagnosticSignWarn",
  linehl = "DiagnosticLineWarn",
  numhl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignHint", {
  text = "󰌵",
  texthl = "DiagnosticSignHint",
  linehl = "",
  numhl = "DiagnosticSignHint",
})
vim.fn.sign_define("DiagnosticSignInfo", {
  text = "●",
  texthl = "DiagnosticSignInfo",
  linehl = "",
  numhl = "DiagnosticSignInfo",
})

-- =====================
-- Autosave (debounced, 1s delay)
-- =====================
local autosave_timer = vim.uv.new_timer()

local function schedule_save()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.bo[buf].modifiable or not vim.bo[buf].modified then
    return
  end
  if vim.bo[buf].buftype ~= "" then
    return
  end
  if vim.api.nvim_buf_get_name(buf) == "" then
    return
  end

  autosave_timer:stop()
  autosave_timer:start(1000, 0, vim.schedule_wrap(function()
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent! write")
      end)
    end
  end))
end

vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI", "FocusLost" }, {
  group = "AutoSave",
  callback = schedule_save,
})
