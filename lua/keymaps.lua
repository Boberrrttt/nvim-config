local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Grow window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Shrink window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Shrink window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Grow window width" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "J", "mzJ`z", { desc = "Join lines keep cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
map("n", "<leader>f", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })
map("n", "<leader>r", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent files" })
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "Buffers" })
map("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { noremap = true, silent = true })
map("n", "<C-S-f>", function()
  require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "Search in project" })
map("n", "<leader>ss", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })
map("n", "<leader>sS", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Workspace symbols" })
map("n", "<leader>xx", function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end, { desc = "Buffer diagnostics" })
map("n", "<leader>xX", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Workspace diagnostics" })
map("n", "<leader>gs", function()
  require("telescope.builtin").git_status()
end, { desc = "Git status" })

map("n", "<leader>R", function()
  local old_name = vim.fn.expand("%:p")
  if old_name == "" then
    vim.notify("No file name", vim.log.levels.WARN)
    return
  end

  local new_name = vim.fn.input("Rename to: ", old_name)
  if new_name == "" or new_name == old_name then
    return
  end

  local ok, err = os.rename(old_name, new_name)
  if not ok then
    vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  vim.cmd.edit(vim.fn.fnameescape(new_name))
  vim.cmd.bdelete(vim.fn.bufnr(old_name))
  vim.notify("Renamed to " .. new_name)
end, { desc = "Rename current file" })

map("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true, desc = "Git diff split" })
map("n", "<leader>gg", function()
  require("lazygit_config").toggle()
end, { noremap = true, silent = true, desc = "Toggle lazygit" })
map("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
map("n", "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })
map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview close" })

map("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify("Copied path")
end, { desc = "Copy file path" })

map("v", "<C-c>", '"+y', { noremap = true, silent = true })
map("v", "<C-x>", '"+d', { noremap = true, silent = true })
map("n", "<C-x>", '"+dd', { noremap = true, silent = true })
map("n", "<C-v>", '"+p', { noremap = true, silent = true })
map("i", "<C-v>", "<C-r>+", { noremap = true, silent = true })

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
map("n", "<leader>q", "<cmd>BDelete this<CR>", { noremap = true, silent = true, desc = "Close tab" })
map("n", "<leader>Q", "<cmd>BDelete other<CR>", { noremap = true, silent = true, desc = "Close other tabs" })

map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle undo tree" })

map("n", "<leader>e", ":Neotree toggle left filesystem<CR>", { noremap = true, silent = true, desc = "Toggle explorer" })
map("n", "<leader>eg", ":Neotree float git_status<CR>", { noremap = true, silent = true, desc = "Git status tree" })
map("n", "<leader>eb", ":Neotree toggle left buffers<CR>", { noremap = true, silent = true, desc = "Buffers tree" })

map("n", "<leader>df", function()
  vim.diagnostic.open_float(nil, { focus = true, scope = "cursor" })
end, { noremap = true, silent = true, desc = "Diagnostic float (line)" })
map("n", "<leader>y", function()
  CopyLineDiagnostics()
end, { noremap = true, silent = true, desc = "Yank line diagnostics" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { noremap = true, silent = true, desc = "Next diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { noremap = true, silent = true, desc = "Prev diagnostic" })

for i = 1, 9 do
  map(
    { "n", "t" },
    "<C-\\>" .. tostring(i),
    "<cmd>" .. i .. "ToggleTerm direction=float<CR>",
    { noremap = true, silent = true, desc = "Toggle floating terminal " .. i }
  )
end

map({ "n", "t" }, "<C-\\><C-\\>", function()
  if vim.bo.filetype ~= "toggleterm" then
    return
  end
  local _, term = require("toggleterm.terminal").identify()
  if term and term:is_open() then
    term:close()
  end
end, { noremap = true, silent = true, desc = "Close floating terminal" })

map("n", "<leader>n", function()
  require("toggleterm.terminal").Terminal:new({ direction = "float" }):toggle()
end, { desc = "Open new floating terminal" })

local resize_float = require("toggleterm_config").resize_float
map({ "n", "t" }, "<C-\\>]", function()
  resize_float(5)
end, { noremap = true, silent = true, desc = "Grow floating terminal" })
map({ "n", "t" }, "<C-\\>[", function()
  resize_float(-5)
end, { noremap = true, silent = true, desc = "Shrink floating terminal" })

map("n", "<leader>tw", function()
  require("kanagawa_themes").load("wave")
end, { noremap = true, silent = true, desc = "Kanagawa wave theme" })
map("n", "<leader>td", function()
  require("kanagawa_themes").load("dragon")
end, { noremap = true, silent = true, desc = "Kanagawa dragon theme" })
map("n", "<leader>tl", function()
  require("kanagawa_themes").load("lotus")
end, { noremap = true, silent = true, desc = "Kanagawa lotus theme" })

map("n", "<leader>pp", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.expand("$USERPROFILE/.cursor/plans") })
end, { desc = "Open plans" })
map("n", "<leader>pm", "<cmd>MarkdownPreviewToggle<CR>", { noremap = true, silent = true, desc = "Toggle markdown preview" })
map("n", "<leader>sr", "<cmd>AutoSession restore<CR>", { desc = "Restore session" })
