require("nvim-treesitter.configs").setup({
  ensure_installed = { "vim", "vimdoc", "lua", "cpp", "bash", "c", "rust", "zig", "python" },

  sync_install = false,
  auto_install = false,

  highlight = { enable = true },

  indent = { enable = true },
})
