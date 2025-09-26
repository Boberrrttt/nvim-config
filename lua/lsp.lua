-- ========================================
-- Neovim LSP + ML Project Configuration (Windows)
-- ========================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Helper: detect root directory for projects
local function get_root_dir(fname)
  local util = require("lspconfig.util")
  return util.root_pattern("package.json", "tsconfig.json", ".git")(fname)
      or vim.loop.cwd()
end

local function get_python_root(fname)
  local util = require("lspconfig.util")
  return util.root_pattern("pyproject.toml", "setup.py", ".git")(fname)
      or util.path.dirname(fname)  -- fallback to folder containing file
end

-- =====================
-- Common on_attach for all LSPs
-- =====================
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Go to definition (across files, like VSCode Ctrl+Click)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  -- Go to declaration
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  -- Hover docs
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  -- List references
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  -- Rename symbol
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  -- Code actions
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

-- =====================
-- TypeScript / JavaScript
-- =====================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function(args)
    vim.lsp.start({
      name = "ts_ls",
      cmd = {
        "cmd.exe",
        "/c",
        "C:\\Users\\QRF_1\\AppData\\Roaming\\npm\\typescript-language-server.cmd",
        "--stdio",
      },
      root_dir = get_root_dir(args.file),
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
})

-- =====================
-- Python (for ML) - Windows + venv support
-- =====================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(args)
    local venv = os.getenv("VIRTUAL_ENV")
    local python_path = venv and (venv .. "\\Scripts\\python.exe") or "python"

    -- Windows full path to pyright-langserver.cmd
    local pyright_cmd = "C:\\Users\\QRF_1\\AppData\\Roaming\\npm\\pyright-langserver.cmd"

    vim.lsp.start({
      name = "pyright",
      cmd = { "cmd.exe", "/c", pyright_cmd, "--stdio" },
      root_dir = get_python_root(args.file),
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          pythonPath = python_path,
        },
      },
    })
  end,
})

-- =====================
-- Diagnostics
-- =====================
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = true,
})

local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
for type, icon in pairs(signs) do
  vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
end

-- =====================
-- Autosave
-- =====================
vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
  group = "AutoSave",
  callback = function()
    if vim.bo.modifiable and vim.bo.modified then
      vim.cmd("silent! write")
    end
  end,
})
