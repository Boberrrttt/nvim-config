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

-- File explorer
require("neo_tree_config")


require("toggleterm_config")


require("theme")

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  callback = function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then gitsigns.refresh() end
  end,
})
