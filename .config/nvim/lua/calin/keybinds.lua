vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- smart case

-- vim.opt.numberwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8 -- there are always at least 8 lines visible above the cursor, and 8 lines visible below the cursor
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50