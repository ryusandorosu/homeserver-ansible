vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h12"

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.guicursor = "i-c-v-n:block"

-- indentation/tabbing settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true -- при переносе строки добавлять отступы

-- enable undo after file closing
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.shada = "!,'1000,<50,s10,h"
vim.opt.confirm = true