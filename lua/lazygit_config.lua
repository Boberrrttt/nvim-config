local p = require("palette")

local term

local function get_term()
  if term then
    return term
  end
  local Terminal = require("toggleterm.terminal").Terminal
  term = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "rounded",
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.85),
      winblend = 10,
    },
    highlights = {
      Normal = { guibg = p.bg2 },
      NormalFloat = { guibg = p.bg2 },
      FloatBorder = { guifg = p.border, guibg = p.bg2 },
    },
    on_open = function()
      vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
    end,
  })
  return term
end

local function toggle()
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify(
      "lazygit not on PATH. Install: winget install -e --id JesseDuffield.lazygit — then restart Neovim.",
      vim.log.levels.ERROR
    )
    return
  end
  get_term():toggle()
end

return { toggle = toggle }
