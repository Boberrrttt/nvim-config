local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = " ",
    path_display = { "smart" },
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
    file_ignore_patterns = { "node_modules", ".git/", "dist" },
    mappings = {
      i = { ["<C-h>"] = "which_key", ["<C-d>"] = actions.delete_buffer },
      n = { ["dd"] = actions.delete_buffer },
    },
  },
  pickers = {
    find_files = { hidden = true, file_ignore_patterns = { "node_modules", "dist", ".git" } },
    live_grep = { additional_args = function() return { "--hidden" } end },
  },
  extensions = {
    fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
  },
})
pcall(telescope.load_extension, "fzf")
