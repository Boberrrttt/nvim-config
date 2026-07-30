-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Sessions: save on exit for manual `:AutoSession restore` — do not auto-restore (clean layout: neo-tree + code)
  {
    "rmagatti/auto-session",
    lazy = false,
    priority = 999,
    opts = {
      auto_save = true,
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Downloads", "/" },
      -- Keep floating/special windows so toggleterm floats can be saved in the session
      close_unsupported_windows = false,
      -- Do not persist undotree in sessions (open only with <leader>u)
      close_filetypes_on_save = { "checkhealth", "undotree" },
      post_restore_cmds = {
        function()
          vim.schedule(function()
            pcall(vim.cmd, "silent! UndotreeHide")
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) then
                local ft = vim.bo[buf].filetype
                local name = vim.api.nvim_buf_get_name(buf)
                if ft == "undotree" or name:find("diffpanel_", 1, true) then
                  pcall(vim.api.nvim_buf_delete, buf, { force = true })
                end
              end
            end
          end)
        end,
      },
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.opt.laststatus = 3
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
      })
      vim.opt.background = "dark"
      vim.cmd.colorscheme("kanagawa")
      require("palette").refresh()
    end,
  },

  -- Status line
  { "nvim-lualine/lualine.nvim" },

  -- Buffer tabs (VS Code–style tab bar)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  { "tpope/vim-eunuch" },

  -- Syntax highlighting & code parsing
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- ponytail: no C compiler on PATH; skip ensure_installed/auto_install noise
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  { "HiPhish/rainbow-delimiters.nvim" },

  -- Autocompletion & snippets (buffer/path/luasnip need matching cmp-* plugins or sources break)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },
  { "onsails/lspkind-nvim" },

  -- LSP
  -- Load early so bundled `lsp/*.lua` configs merge with `vim.lsp.config()` (Nvim 0.11+)
  { "neovim/nvim-lspconfig", lazy = false },

  -- Terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = function()
      if vim.fn.has("win32") == 1 then
        vim.fn.system("cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release")
        vim.fn.system("cmake --build build --config Release")
      else
        vim.fn.system("make")
      end
    end,
  },

  -- Buffer deletion
  { "kazhala/close-buffers.nvim", config = true },

  -- Indentation guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },

  -- Commenting
  { "numToStr/Comment.nvim", opts = {} },

  -- Debugging
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      watch_gitdir = { follow_files = true },
      current_line_blame = true,
      current_line_blame_opts = { delay = 600, virt_text_pos = "eol" },
      current_line_blame_formatter = "<author>, <author_time:%R> · <summary>",
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, opts)
        vim.keymap.set("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, opts)
        vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, opts)
        vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, opts)
        vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, opts)
        vim.keymap.set("n", "<leader>hb", gitsigns.toggle_current_line_blame, opts)
        vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, opts)
      end,
    },
  },
  { "tpope/vim-fugitive" },

  -- Undo history panel (see lua/undotree_config.lua — needs `diff` / Git diff.exe on Windows)
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function()
      require("undotree_config")
    end,
  },

  -- Icons: devicons + material icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,      -- enable fallback icons
        color_icons = true,  -- colored icons
      })
    end,
  },

  {
    "DaikyXendo/nvim-material-icon",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
        color_icons = true,
      })
    end,
  },

  -- Neo-tree (depends on devicons + material icons)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "DaikyXendo/nvim-material-icon",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo_tree_config")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { max_lines = 3, separator = "─" },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        options = {
          show_source = { enabled = true },
          multilines = { enabled = true, always_show = true },
          overflow = { mode = "wrap" },
        },
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

}, {
  ui = {
    border = "rounded",
    -- string required (not boolean); nil also valid
    title = " lazy.nvim ",
    title_pos = "center",
    backdrop = 60,
  },
})
