local function join_paths(...)
  local sep = package.config:sub(1, 1) -- / on Unix, \ on Windows
  return table.concat({ ... }, sep)
end

require("oil").setup({
  columns = {
    "icon", "size", "permissions", "mtime", "type",
  },
  keymaps = {
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-t>"] = "actions.select_tab",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",

    -- Copy
    ["yy"] = function()
      local oil = require("oil")
      local entry = oil.get_cursor_entry()
      if entry and entry.path then
        vim.fn.setreg('"', entry.path)
        print("Copied: " .. entry.path)
      end
    end,

    -- Delete with confirmation
    ["dd"] = function()
      local oil = require("oil")
      local entry = oil.get_cursor_entry()
      if not entry or not entry.name then return end

      local dir = oil.get_current_dir()
      local path = join_paths(dir, entry.name)
      local confirm = vim.fn.input("Delete " .. entry.name .. "? (y/n): ")
      if confirm:lower() == "y" then
        if vim.fn.isdirectory(path) == 1 then
          vim.fn.delete(path, "rf")
        else
          vim.fn.delete(path)
        end
        oil.open(dir)
      else
        print("Cancelled")
      end
    end,

    -- Delete without confirmation
    ["D"] = function()
      local oil = require("oil")
      local entry = oil.get_cursor_entry()
      if entry and entry.path then
        if vim.fn.isdirectory(entry.path) == 1 then
          vim.fn.delete(entry.path, "rf")
        else
          vim.fn.delete(entry.path)
        end
        oil.open(oil.get_current_dir())
      end
    end,

    -- Paste (copy file/dir into current folder)
    ["p"] = function()
      local oil = require("oil")
      local dir = oil.get_current_dir()
      if not dir then return end
      local copied = vim.fn.getreg('"')
      if copied ~= "" then
        local name = copied:match("[^/\\]+$")
        os.execute(string.format('cp -r "%s" "%s"', copied, join_paths(dir, name)))
        oil.open(dir)
        print("Pasted: " .. name)
      end
    end,

    -- Rename
    ["r"] = function()
      local oil = require("oil")
      local entry = oil.get_cursor_entry()
      if not entry or not entry.name then return end

      local old_name = entry.name
      local new_name = vim.fn.input("Rename file: ", old_name)
      if new_name == "" or new_name == old_name then return end

      local dir = oil.get_current_dir()
      local old_path = entry.path or join_paths(dir, old_name)
      local new_path = join_paths(dir, new_name)

      local ok, err = os.rename(old_path, new_path)
      if not ok then
        print("Error renaming:", err)
        return
      end

      oil.open(dir)
      print("Renamed " .. old_name .. " → " .. new_name)
    end,

    -- New file
    ["%"] = function()
      local oil = require("oil")
      local dir = oil.get_current_dir()
      if not dir then return end

      local name = vim.fn.input("New file name: ")
      if name ~= "" then
        local path = join_paths(dir, name)
        vim.fn.writefile({}, path)
        oil.open(dir)
        print("Created file: " .. name)
      end
    end,

    -- New directory
    ["_"] = function()
      local oil = require("oil")
      local dir = oil.get_current_dir()
      if not dir then return end

      local name = vim.fn.input("New directory name: ")
      if name ~= "" then
        vim.fn.mkdir(join_paths(dir, name), "p")
        oil.open(dir)
        print("Created directory: " .. name)
      end
    end,

-- ===== MOVE FILE SUPPORT =====
-- Mark file for moving
["ym"] = function()
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  if not entry or not entry.name then return end

  local dir = oil.get_current_dir()
  local full_path = entry.path or join_paths(dir, entry.name)

  vim.g.oil_cut_file = full_path
  print("Marked for move: " .. full_path)
end,

-- Paste move (move file into current folder)
["P"] = function()
  local oil = require("oil")
  local dir = oil.get_current_dir()
  local cut_file = vim.g.oil_cut_file
  if not dir or not cut_file then return end

  local name = cut_file:match("[^/\\]+$")
  local new_path = join_paths(dir, name)

  local ok, err = os.rename(cut_file, new_path)
  if not ok then
    print("Error moving file:", err)
  else
    print("Moved " .. cut_file .. " → " .. new_path)
    vim.g.oil_cut_file = nil
    oil.open(dir)
  end
end,

  },
})
