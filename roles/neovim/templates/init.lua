vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.g.mapleader = " "
require("config.clipboard")
require("config.keybindings")
require("config.lazy")
require("config.filetypes")
vim.cmd.colorscheme("gruvbox")
vim.opt.termguicolors = true
vim.opt.guicursor = "i-c-v-n:block"
-- opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor20"
-- opt.guifont = "JetBrainsMono Nerd Font:h12"
