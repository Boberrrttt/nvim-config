local dap = require("dap")
local dapui = require("dapui")

require("nvim-dap-virtual-text").setup({
  commented = true,
  highlight_changed_variables = true,
})

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.45 },
        { id = "breakpoints", size = 0.2 },
        { id = "stacks", size = 0.2 },
        { id = "watches", size = 0.15 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = { "repl", "console" },
      size = 0.25,
      position = "bottom",
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local python = os.getenv("VIRTUAL_ENV") and (os.getenv("VIRTUAL_ENV") .. "\\Scripts\\python.exe") or "python"
dap.adapters.python = {
  type = "executable",
  command = python,
  args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
  },
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "DiagnosticLineWarn", numhl = "" })

vim.keymap.set("n", "<F5>", function()
  dap.continue()
end, { desc = "DAP Continue" })
vim.keymap.set("n", "<F9>", function()
  dap.toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", function()
  dap.step_over()
end, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", function()
  dap.step_into()
end, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", function()
  dap.step_out()
end, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>db", function()
  dap.toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>du", function()
  dapui.toggle()
end, { desc = "DAP UI Toggle" })
vim.keymap.set("n", "<leader>dr", function()
  dap.repl.open()
end, { desc = "DAP REPL" })
vim.keymap.set("n", "<leader>dl", function()
  dap.run_last()
end, { desc = "DAP Run Last" })
