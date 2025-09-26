local map = vim.keymap.set

-- Oil + Telescope
map("n", "<leader>e", ":Oil<CR>", { noremap = true, silent = true })
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

-- Buffer nav
map("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
map("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })
map("n", "<leader>q", ":Bdelete<CR>", { noremap = true, silent = true })

-- Ctrl+Shift+F → Search text in project
map("n", "<C-S-f>", function()
  require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "Search in project" })

--  open a brand new floating terminal
vim.keymap.set("n", "<leader>n", function()
  require("toggleterm.terminal").Terminal
    :new({ direction = "float" })
    :toggle()
end, { desc = "Open new floating terminal" })
