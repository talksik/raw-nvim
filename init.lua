-------------------------------------------------------------------------------
-- 1. BASE SETTINGS
-------------------------------------------------------------------------------
vim.g.mapleader = " "              -- Use Space as the leader key
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true     -- Relative numbers for easier jumping
vim.opt.mouse = "a"                -- Enable mouse support
vim.opt.ignorecase = true          -- Case-insensitive searching
vim.opt.smartcase = true           -- ...unless search contains a capital
vim.opt.termguicolors = true       -- Support for 24-bit RGB colors
vim.opt.tabstop = 4                -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4             -- Number of spaces for auto-indent
vim.opt.expandtab = true           -- Turn tabs into spaces
vim.opt.scrolloff = 8              -- Keep 8 lines visible above/below cursor
vim.opt.updatetime = 50            -- Faster completion/experience

-------------------------------------------------------------------------------
-- 2. PLUGIN BOOTSTRAP (lazy.nvim)
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- 3. PLUGIN CONFIGURATION
-------------------------------------------------------------------------------
require("lazy").setup({
  -- Treesitter: Better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      -- In the new version, we use 'nvim-treesitter' directly
      require("nvim-treesitter").setup({ 
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "python" },
        highlight = { enable = true },
      })
    end,
  },

  -- Theme: TokyoNight (Modern, Purist, and Fast)
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- Make sure it loads on startup
    priority = 1000, -- Load it before everything else
    config = function()
      -- Options: "storm", "moon", "night", "day"
      vim.cmd([[colorscheme tokyonight-night]]) 
    end,
  },

  -- FZF-Lua: High performance file search (requires fzf installed on system)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({ "fzf-native" })
    end,
  },
})

-------------------------------------------------------------------------------
-- 4. KEYMAPS (The Purist Workflow)
-------------------------------------------------------------------------------
local fzf = require("fzf-lua")

-- File Searching
vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "Live Grep (Search Text)" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Search Help" })

-- File Browsing (Using built-in Netrw)
-- This opens the directory view so you don't need a heavy 'Tree' plugin
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open Project View" })

-- Essential Remaps
vim.keymap.set("n", "<C-d>", "<C-d>zz")      -- Keep cursor centered when jumping down
vim.keymap.set("n", "<C-u>", "<C-u>zz")      -- Keep cursor centered when jumping up
