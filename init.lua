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