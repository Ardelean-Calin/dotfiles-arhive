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
