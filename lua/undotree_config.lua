-- mbbill/undotree shells out to `diff`; Windows rarely has it on PATH (use Git's diff.exe).
-- Split position: g:undotree_WindowLayout is set in lua/options.lua (must load before the plugin).

local function diff_executable()
  if vim.fn.has("win32") ~= 1 then
    return "diff"
  end
  for _, name in ipairs({ "diff", "diff.exe" }) do
    if vim.fn.executable(name) == 1 then
      local ep = vim.fn.exepath(name)
      if ep ~= "" then
        return ep:gsub("\\", "/")
      end
      return name
    end
  end
  local candidates = {
    vim.env.LOCALAPPDATA and (vim.env.LOCALAPPDATA:gsub("\\", "/") .. "/Programs/Git/usr/bin/diff.exe"),
    vim.env.ProgramFiles and (vim.env.ProgramFiles:gsub("\\", "/") .. "/Git/usr/bin/diff.exe"),
    vim.env["ProgramFiles(x86)"] and (vim.env["ProgramFiles(x86)"]:gsub("\\", "/") .. "/Git/usr/bin/diff.exe"),
  }
  for _, p in ipairs(candidates) do
    if p and vim.fn.filereadable(p) == 1 then
      return p
    end
  end
  return nil
end

local diff = diff_executable()
vim.g.undotree_DiffCommand = diff or "diff"
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_SplitWidth = 32

if not diff and vim.fn.has("win32") == 1 then
  vim.notify(
    "undotree: no diff.exe found. Install Git for Windows or add GNU diff to PATH.",
    vim.log.levels.WARN
  )
end
