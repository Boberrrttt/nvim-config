-- Bootstrap lazy.nvim & load plugins
require("plugins")

-- Core settings
require("options")
require("keymaps")

-- LSP & autocompletion
require("completion")
require("lsp")

-- Telescope
require("telescope_config")


-- Debugger
require("dap_config")

-- File explorer: configured from lazy.nvim (neo-tree plugin `config`)

require("toggleterm_config")


require("theme")

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  callback = function()
    local ok, gitsigns_or_err = pcall(require, "gitsigns")
    if ok then
      gitsigns_or_err.refresh()
    else
      vim.notify("Error loading gitsigns: " .. tostring(gitsigns_or_err), vim.log.levels.ERROR)
    end
  end,
})

