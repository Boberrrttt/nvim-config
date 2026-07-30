-- Options before plugins so sessionoptions applies when auto-session restores
require("options")

-- Bootstrap lazy.nvim & load plugins
require("plugins")

require("keymaps")

-- LSP & autocompletion (LSP after theme so diagnostics highlights / config apply last)
require("completion")

-- Telescope
require("telescope_config")

-- Debugger
require("dap_config")

-- File explorer: configured from lazy.nvim (neo-tree plugin `config`)

require("toggleterm_config")

require("theme")
require("lsp")

