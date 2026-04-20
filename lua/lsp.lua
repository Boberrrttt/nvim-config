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
        "C:\\Users\\robert\\AppData\\Roaming\\npm\\typescript-language-server.cmd",
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
    local pyright_cmd = "C:\\Users\\robert\\AppData\\Roaming\\npm\\pyright-langserver.cmd"

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
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

function CopyLineDiagnostics()
  local bufnr = 0
  local lnum = vim.fn.line('.') - 1
  local diags = vim.diagnostic.get(bufnr, { lnum = lnum })

  if #diags == 0 then
    print("No diagnostics on this line")
    return
  end

  local messages = {}
  for _, d in ipairs(diags) do
    table.insert(messages, d.message)
  end

  vim.fn.setreg('+', table.concat(messages, '\n'))
  print("Diagnostics copied to clipboard!")
end

-- Line background for error/warn lines
vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = "#3D1515" })
vim.api.nvim_set_hl(0, "DiagnosticLineWarn",  { bg = "#2E2612" })

vim.fn.sign_define("DiagnosticSignError", {
  text = " ", texthl = "DiagnosticSignError",
  linehl = "DiagnosticLineError", numhl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
  text = " ", texthl = "DiagnosticSignWarn",
  linehl = "DiagnosticLineWarn", numhl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignHint", {
  text = "󰌵 ", texthl = "DiagnosticSignHint",
  linehl = "", numhl = "DiagnosticSignHint",
})
vim.fn.sign_define("DiagnosticSignInfo", {
  text = " ", texthl = "DiagnosticSignInfo",
  linehl = "", numhl = "DiagnosticSignInfo",
})

-- =====================
-- Autosave (debounced, 1s delay)
-- =====================
local autosave_timer = vim.uv.new_timer()

local function schedule_save()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.bo[buf].modifiable or not vim.bo[buf].modified then return end
  if vim.bo[buf].buftype ~= "" then return end  -- skip non-file buffers (terminal, quickfix, etc.)
  if vim.api.nvim_buf_get_name(buf) == "" then return end  -- skip unnamed buffers

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
