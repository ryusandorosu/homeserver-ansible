vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.g.mapleader = " "
require("config.clipboard")
require("config.lazy")
require("config.lsp")
require("config.cmp")
vim.cmd.colorscheme("gruvbox")
vim.opt.termguicolors = true
require("bufferline").setup{}
