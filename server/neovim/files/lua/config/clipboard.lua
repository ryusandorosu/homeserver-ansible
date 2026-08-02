vim.g.clipboard = {
  name = 'osc52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = function() return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')} end,
    ['*'] = function() return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')} end,
  },
  -- paste = {
  --   ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
  --   ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  -- },
}

vim.opt.clipboard = "unnamedplus"
