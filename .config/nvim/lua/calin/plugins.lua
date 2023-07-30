local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	"folke/neodev.nvim",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"bash",
					"c",
					"lua",
					"rust",
					"vim",
					"vimdoc",
					"query",
					"javascript",
					"html",
					"python",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("calin.plugins.alpha")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("calin.plugins.lualine")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		-- or                              , branch = '0.1.x',
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("calin.plugins.telescope")
		end,
	},
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("calin.plugins.mini")
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
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
		"williamboman/mason.nvim",
		opts = {}, -- required so that the setup() function is called
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "rust_analyzer", "bashls" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("calin.plugins.lsp")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("calin.plugins.null-ls")
		end,
	},
	-- Completion plugin
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/vim-vsnip",
		},
		config = function()
			require("calin.plugins.nvim-cmp")
		end,
	},
	{
		"folke/neodev.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
	{
		"simrat39/rust-tools.nvim",
		opts = {
			server = {
				on_attach = function(_, bufnr)
					-- Hover actions
					vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
					-- Code action groups
					vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
				end,
			},
		},
	},

	-- {
	--   'VonHeikemen/lsp-zero.nvim',
	--   branch = 'v2.x',
	--   dependencies = {
	--     -- LSP Support
	--     { 'neovim/nvim-lspconfig' },             -- Required
	--     { 'williamboman/mason.nvim' },           -- Optional
	--     { 'williamboman/mason-lspconfig.nvim' }, -- Optional
	--
	--     -- Autocompletion
	--     { 'hrsh7th/nvim-cmp' },     -- Required
	--     { 'hrsh7th/cmp-nvim-lsp' }, -- Required
	--     { 'L3MON4D3/LuaSnip' },     -- Required
	--
	--     -- snippets
	--     { 'L3MON4D3/LuaSnip' },
	--     { 'rafamadriz/friendly-snippets' },
	--   },
	--   config = function() require('calin.plugins.lsp') end
	-- }
})
