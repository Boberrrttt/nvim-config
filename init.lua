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

-- Oil (file explorer)
require("oil_config")


require("toggleterm_config")

require("theme")