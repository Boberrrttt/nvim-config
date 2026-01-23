local map = vim.keymap.set

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
map("n", "<leader>f", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
map("n", "<leader>r", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true })
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
map("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { noremap = true, silent = true })

-- Rename current file
map("n", "<leader>R", function()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("Rename to: ", old_name)
  if new_name ~= "" and new_name ~= old_name then
    vim.fn.system({ "mv", old_name, new_name })
    vim.cmd("e " .. new_name)
    vim.cmd("bdelete " .. old_name)
    print("Renamed to " .. new_name)
  end
end, { desc = "Rename current file" })

-- Git-fugitive diff split
map("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true })

-- Clipboard
map("v", "<C-c>", '"+y', { noremap = true, silent = true })
map("v", "<C-x>", '"+d', { noremap = true, silent = true })
map("n", "<C-x>", '"+dd', { noremap = true, silent = true })
map("n", "<C-v>", '"+p', { noremap = true, silent = true })
map("i", "<C-v>", '<C-r>+', { noremap = true, silent = true })

-- Buffer navigation
map("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
map("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })
map("n", "<leader>q", ":Bdelete<CR>", { noremap = true, silent = true })

-- Neo-tree (file explorer)
map("n", "<leader>e", ":Neotree toggle left<CR>", { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Ctrl+Shift+F → Search text in project
map("n", "<C-S-f>", function()
  require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "Search in project" })

-- Open new floating terminal
map("n", "<leader>n", function()
  require("toggleterm.terminal").Terminal:new({ direction = "float" }):toggle()
end, { desc = "Open new floating terminal" })

vim.api.nvim_set_keymap(
  "n",
  "<leader>e",  
  "<cmd>lua vim.diagnostic.open_float()<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>y",              
  "<cmd>lua CopyLineDiagnostics()<CR>",
  { noremap = true, silent = true }
)

