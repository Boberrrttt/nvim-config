local dap = require("dap")
local dapui = require("dapui")

require("nvim-dap-virtual-text").setup()
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "DAP REPL" })
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "DAP Run Last" })

dap.listeners.after.event_stopped["open_repl"] = function(session, body)
  dap.repl.open()
end

dap.listeners.after.event_terminated["notify_error"] = function(session, body)
  vim.schedule(function()
    local msg = "Debugger session terminated.\nDetails: " .. vim.inspect(body)
    vim.notify(msg, vim.log.levels.WARN)
  end)
end

