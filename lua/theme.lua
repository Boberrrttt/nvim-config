vim.opt.background = "dark"

-- Base background and foreground
vim.cmd("hi Normal guibg=#000000 guifg=#C8D6D5")          -- black background, white text
vim.cmd("hi CursorLine guibg=#1A1C2B")                    -- subtle highlight for current line
vim.cmd("hi LineNr guifg=#3EB489 guibg=#000000")          -- green line numbers
vim.cmd("hi CursorLineNr guifg=#3EB489 guibg=#1A1C2B")    -- green current line number
vim.cmd("hi StatusLine guibg=#1A1C2B guifg=#3EB489")      -- green statusline
vim.cmd("hi StatusLineNC guibg=#000000 guifg=#C8D6D5")    -- inactive statusline white
vim.cmd("hi Visual guibg=#003333 guifg=#C8D6D5")          -- dark cyan highlight

-- Oil.nvim highlights (directories/files/etc.)
vim.cmd("hi OilDir guifg=#3EB489 guibg=#000000 gui=bold")      -- directories green
vim.cmd("hi OilFile guifg=#C8D6D5 guibg=#000000")              -- files white
vim.cmd("hi OilLink guifg=#3EB489 guibg=#000000 gui=italic")   -- symlinks green italic
vim.cmd("hi OilSocket guifg=#3EB489 guibg=#000000 gui=bold")   -- sockets green bold
vim.cmd("hi OilSplit guibg=#000000")                           -- split stays black

-- Syntax highlighting (only white + green)
vim.cmd("hi Comment guifg=#3EB489 guibg=#000000 gui=italic")   -- green italic comments
vim.cmd("hi String guifg=#3EB489 guibg=#000000")               -- green strings
vim.cmd("hi Keyword guifg=#C8D6D5 guibg=#000000 gui=bold")     -- white bold keywords
vim.cmd("hi Function guifg=#3EB489 guibg=#000000 gui=bold")    -- green functions
vim.cmd("hi Operator guifg=#C8D6D5 guibg=#000000")             -- white operators
vim.cmd("hi Constant guifg=#3EB489 guibg=#000000 gui=bold")    -- green constants
vim.cmd("hi Type guifg=#C8D6D5 guibg=#000000 gui=bold")        -- white types
vim.cmd("hi Identifier guifg=#3EB489 guibg=#000000")           -- green identifiers

-- Search highlights
vim.cmd("hi Search guibg=#3A4750 guifg=#C8D6D5")
vim.cmd("hi IncSearch guibg=#3EB489 guifg=#000000")
