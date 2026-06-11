local p = require("palette")

local config_dir = vim.fn.stdpath("config")
local script_path = config_dir .. "/scripts/open-from-lazygit.ps1"
local lg_config_path = config_dir .. "/lazygit.yml"

local function write_lazygit_config()
  local edit = string.format(
    'powershell -NoProfile -ExecutionPolicy Bypass -File "%s" -Path "{{filename}}"',
    script_path
  )
  local edit_at_line = string.format(
    'powershell -NoProfile -ExecutionPolicy Bypass -File "%s" -Path "{{filename}}" -Line {{line}}',
    script_path
  )
  vim.fn.writefile({
    "promptToReturnFromSubprocess: false",
    "os:",
    "  editPreset: ''",
    "  edit: '" .. edit .. "'",
    "  editAtLine: '" .. edit_at_line .. "'",
    "  editAtLineAndWait: '" .. edit_at_line .. "'",
  }, lg_config_path)
end

write_lazygit_config()

local term

local function get_term()
  if term then
    return term
  end
  local Terminal = require("toggleterm.terminal").Terminal
  term = Terminal:new({
    cmd = "lazygit",
    env = {
      LG_CONFIG_FILE = lg_config_path,
    },
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

local function open_file(path, line)
  line = tonumber(line) or 0
  local t = get_term()
  if t and t:is_open() then
    t:close()
  end
  vim.schedule(function()
    vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(path, ":p")))
    if line > 0 then
      pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
    end
  end)
  return 0
end

return { toggle = toggle, open_file = open_file }
