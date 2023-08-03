-- This enables a 300ms timeout which which-key can use.
vim.o.timeout = true
vim.o.timeoutlen = 300
require("which-key").setup({})
