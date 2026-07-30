# Neovim keymap cheat sheet

`<leader>` = **Space**

Modes: `n` normal · `i` insert · `v` visual · `t` terminal

---

## Navigation & windows

| Key | What |
|-----|------|
| `Ctrl-h/j/k/l` | Move between windows |
| `Ctrl-←/↓/↑/→` | Resize window |
| `Ctrl-d` / `Ctrl-u` | Page down/up (centered) |
| `n` / `N` | Next/prev search (centered) |
| `Esc` | Clear search highlight |
| `J` | Join lines (keep cursor) |

## Editing

| Key | Mode | What |
|-----|------|------|
| `<` / `>` | v | Indent (keep selection) |
| `J` / `K` | v | Move selection down/up |
| `Ctrl-c` | v | Copy to clipboard |
| `Ctrl-x` | n/v | Cut line / selection |
| `Ctrl-v` | n/i | Paste clipboard |
| `<leader>cp` | n | Copy file path |
| `<leader>R` | n | Rename current file |
| `<leader>u` | n | Undo tree |
| `gcc` / `gc` | n/v | Comment (Comment.nvim) |

## Find (Telescope)

| Key | What |
|-----|------|
| `Ctrl-p` | Find files |
| `Ctrl-f` | Fuzzy find in buffer |
| `Ctrl-Shift-f` / `<leader>f` | Search text in project |
| `<leader>r` | Recent files |
| `<leader>b` | Open buffers |
| `<leader>ss` | Document symbols |
| `<leader>sS` | Workspace symbols |
| `<leader>xx` | Buffer diagnostics list |
| `<leader>xX` | Workspace diagnostics list |
| `<leader>gs` | Git status picker |
| `<leader>pp` | Open Cursor plans |

## Tabs (bufferline)

| Key | What |
|-----|------|
| `Tab` / `Shift-Tab` | Next / prev tab |
| `<leader>1`…`9` | Go to tab 1–9 |
| `<leader>0` | Last tab |
| `<leader>q` | Close tab |
| `<leader>Q` | Close other tabs |

## File explorer (neo-tree)

| Key | What |
|-----|------|
| `<leader>e` | Toggle Files tree |
| `<leader>eb` | Toggle Buffers tree |
| `<leader>eg` | Git status (float) |
| `]` / `[` | Next / prev source (Files ↔ Bufs ↔ Git) |
| `o` | Open |
| `Space` | Expand/collapse folder |
| `C` | Close node |
| `R` | Refresh |
| `H` | Toggle hidden files |
| `P` | Preview float |
| `Y` | Copy path to clipboard |

## Git

| Key | What |
|-----|------|
| `<leader>dv` | Diffview (all changes) |
| `<leader>dh` | Diffview file history |
| `<leader>dc` | Close Diffview |
| `<leader>gd` | Fugitive diff split |
| `<leader>gg` | Lazygit |
| `<leader>hd` | Diff this file (gitsigns) |
| `<leader>hp` | Preview hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hb` | Toggle line blame |
| `]c` / `[c` | Next / prev hunk |

## LSP & diagnostics

| Key | What |
|-----|------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `gr` | References |
| `K` | Hover docs |
| `gs` | Signature help |
| `Ctrl-s` | Signature help (insert) |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>fm` | Format buffer |
| `<leader>df` | Diagnostic float (focusable) |
| `<leader>y` | Yank line diagnostics |
| `]d` / `[d` | Next / prev diagnostic |

## Debugger (DAP)

| Key | What |
|-----|------|
| `F5` | Continue / start |
| `F9` / `<leader>db` | Toggle breakpoint |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | DAP REPL |
| `<leader>dl` | Run last |

## Terminal (toggleterm)

| Key | What |
|-----|------|
| `Ctrl-\` then `1`–`9` | Toggle float terminal 1–9 |
| `Ctrl-\` `Ctrl-\` | Close focused float terminal |
| `Ctrl-\` `]` / `[` | Grow / shrink float terminal |
| `<leader>n` | New float terminal |

## Completion (insert)

| Key | What |
|-----|------|
| `Ctrl-Space` | Open completion |
| `Enter` | Confirm |
| `Tab` / `Shift-Tab` | Next / prev (or snippet jump) |

## Theme & extras

| Key | What |
|-----|------|
| `<leader>tw` | Kanagawa wave |
| `<leader>td` | Kanagawa dragon |
| `<leader>tl` | Kanagawa lotus |
| `<leader>pm` | Markdown preview toggle |
| `<leader>sr` | Restore session |
