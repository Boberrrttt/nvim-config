-- Hidden buffers survive when switching away (toggleterm README; also helps session save)
vim.opt.hidden = true

-- rmagatti/auto-session: include :terminal / toggleterm in Session.vim (see :h sessionoptions)
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "winpos",
  "terminal",
  "localoptions",
}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.g.mapleader = " "
vim.opt.termguicolors = true

-- mbbill/undotree: before plugin loads, else default layout 1 = left. :h undotree_WindowLayout
-- 3 = code left; undo tree + diff panel both in the right column (4 puts diff full-width on the bottom)
vim.g.undotree_WindowLayout = 3

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  callback = function()
    require("gitsigns").refresh()
  end,
})
