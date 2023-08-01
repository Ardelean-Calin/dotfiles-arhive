local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup {
  -- Themes
  { "catppuccin/nvim",    name = "catppuccin", priority = 1000 },
  { "sainnhe/everforest", name = "everforest", priority = 1000 },

  "folke/neodev.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "calin.plugins.treesitter"
    end,
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require "calin.plugins.alpha"
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require "calin.plugins.lualine"
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
  },
  { "lewis6991/gitsigns.nvim",          opts = {} },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    tag = "0.1.2",
    -- or                              , branch = '0.1.x',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "calin.plugins.telescope"
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require "calin.plugins.mini"
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc =
        "Flash Treesitter"
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc =
        "Remote Flash"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc =
        "Treesitter Search"
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc =
        "Toggle Flash Search"
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },
  {
    "tpope/vim-fugitive",
    config = function() end,
  },
  -- Mason. Install LSPs and Linters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "beautysh",
        -- "flake8",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  { "williamboman/mason-lspconfig.nvim" },
  -- LSP
  { "neovim/nvim-lspconfig" },
  {
    "folke/neodev.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {},
  },
  -- Completion engine
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },
  -- Formatters
  -- Some LSPs, such as bashls, do not provide formatting services. This means vim.lsp.buf.format() doesn't work.
  -- In order to make such LSPs to support formatting, we use null-ls together with a formatter to expose a
  -- formatting API to Neovims LSP engine. At least that's how I understand it.
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local null_ls = require "null-ls"
      return {
        sources = {
          null_ls.builtins.formatting.beautysh,
          null_ls.builtins.formatting.stylua,
        },
      }
    end,
  },
}
-- Load the LSP configuration
require "calin.plugins.lsp"
require "calin.plugins.completions"
