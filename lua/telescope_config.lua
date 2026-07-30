local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = " ",
    path_display = { "smart" },
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      flex = { flip_columns = 140 },
    },
    file_ignore_patterns = { "node_modules", ".git/", "dist", "%.lock" },
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
        ["<C-d>"] = actions.delete_buffer,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
      n = {
        ["dd"] = actions.delete_buffer,
        ["q"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = { hidden = true, file_ignore_patterns = { "node_modules", "dist", "%.git" } },
    live_grep = {
      additional_args = function()
        return { "--hidden", "--glob", "!.git/*" }
      end,
    },
    buffers = { sort_mru = true, ignore_current_buffer = true },
    diagnostics = { sort_by = "severity" },
  },
  extensions = {
    fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
  },
})
pcall(telescope.load_extension, "fzf")
