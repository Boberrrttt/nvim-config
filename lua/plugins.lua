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
  -- Status line
  { "nvim-lualine/lualine.nvim" },

  { "tpope/vim-eunuch" },

  -- Syntax highlighting & code parsing
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "p00f/nvim-ts-rainbow" },

  -- Autocompletion & snippets
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },
  { "onsails/lspkind-nvim" },

  -- LSP
  { "neovim/nvim-lspconfig" },

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
  { "kazhala/close-buffers.nvim" },

  -- Indentation guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },

  -- Commenting
  { "numToStr/Comment.nvim" },

  -- Debugging
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },

  -- Git
  { "lewis6991/gitsigns.nvim" },
  { "tpope/vim-fugitive" },

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

})
