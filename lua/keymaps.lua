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

-- Buffer tabs (bufferline order — matches tab bar, not raw :bnext order)
map("n", "<TAB>", "<cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Next tab" })
map("n", "<S-TAB>", "<cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Previous tab" })
map("n", "<leader>0", "<cmd>BufferLineGoToBuffer -1<CR>", { noremap = true, silent = true, desc = "Last tab" })
for i = 1, 9 do
  map(
    "n",
    "<leader>" .. i,
    "<cmd>BufferLineGoToBuffer " .. i .. "<CR>",
    { noremap = true, silent = true, desc = "Go to tab " .. i }
  )
end
map("n", "<leader>q", ":Bdelete<CR>", { noremap = true, silent = true })

-- Neo-tree (file explorer) — <leader>e = explorer only (no duplicate binding)
map("n", "<leader>e", ":Neotree toggle left<CR>", { noremap = true, silent = true, desc = "Toggle file explorer" })
map("n", "<leader>df", function()
  vim.diagnostic.open_float()
end, { noremap = true, silent = true, desc = "Diagnostic float (line)" })
map("n", "<leader>y", function()
  CopyLineDiagnostics()
end, { noremap = true, silent = true, desc = "Yank line diagnostics" })


-- Ctrl+Shift+F → Search text in project
map("n", "<C-S-f>", function()
  require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "Search in project" })

-- Toggleterm: Ctrl+\ then 1–9 toggles that terminal index (same float layout as toggleterm_config)
for i = 1, 9 do
  map(
    { "n", "t" },
    "<C-\\>" .. tostring(i),
    "<cmd>" .. i .. "ToggleTerm direction=float<CR>",
    { noremap = true, silent = true, desc = "Toggle floating terminal " .. i }
  )
end

-- Open new floating terminal (extra instance; does not use the 1–9 slots)
map("n", "<leader>n", function()
  require("toggleterm.terminal").Terminal:new({ direction = "float" }):toggle()
end, { desc = "Open new floating terminal" })
