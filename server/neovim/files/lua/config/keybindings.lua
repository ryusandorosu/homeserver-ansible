-- :help default-mappings
-- :h nvim-surround.configuration -- default is 'S' when selected in visual mode
-- :h comment.config -- default is 'gc'(nv) - opleader and 'gcc'(n) - toggler for selected lines. redefined to 'c' and 'cc'
-- REMINDER: ctrl-q (by default) and button: returns <key>; <cr> = enter, <cmd> = ':'
vim.g.mapleader = " "

vim.keymap.set('n',       '<C-w>',      ':w<CR>',         { desc = "Save the file" })
vim.keymap.set('n',       '<C-q>',      ':q<CR>',         { desc = "Close current window" })
vim.keymap.set('n',       '<C-x>',      ':q!<CR>',        { desc = "Close all windows!" }) --:quitall/:qa
-- selection
vim.keymap.set({'n','v'}, '<C-a>',      'ggVG',           { desc = "Select all text" })
vim.keymap.set('i',       '<C-a>',      '<Esc>ggVG',      { desc = "Select all text" })
-- split window
vim.keymap.set('n',       '<leader>h',  ':split<CR>',     { desc = "Horizontal split" })
vim.keymap.set('n',       '<leader>v',  ':vsplit<CR>',    { desc = "Vertical split" })

-- window-picker
vim.keymap.set('n', '<leader>q',        ':bdelete<CR>',   { desc = "Close current buffer" })
vim.keymap.set('n', '<leader><Right>',  ':bnext<CR>',     { desc = "Switch to next buffer" })
vim.keymap.set('n', '<leader><Left>',   ':bprevious<CR>', { desc = "Switch to previous buffer" })
vim.keymap.set('n', '<leader><Tab>', function()
  local window_id = require('window-picker').pick_window()
  vim.api.nvim_set_current_win(window_id)
end, { desc = "Pick window" })

-- neotree
vim.keymap.set('n', '<leader><space>',  ':Neotree <CR>',  { desc = "Neotree" })
-- vim.keymap.set('n', '<leader><space>', function() Snacks.explorer() end, { desc = "File Explorer" })
-- telescope
vim.keymap.set('n', '<leader>f',  ':Telescope find_files<cr>')
vim.keymap.set('n', '<leader>g',  ':Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>b',  ':Telescope buffers<cr>')
vim.keymap.set('n', '<leader>c',  ':Telescope commands<cr>')
vim.keymap.set('n', '<leader>fc', ':Telescope command_history<cr>')
vim.keymap.set('n', '<leader>k',  ':Telescope keymaps<cr>')
-- useful for debugging
vim.keymap.set('n', '<leader>i',  ':Inspect<cr>')
-- алсо неедед а кеймап то релоад нвим

-- line moving
vim.keymap.set('n', '<C-Up>',     ':m .-2<CR>==',         { desc = "Move line up" })
vim.keymap.set('n', '<C-Down>',   ':m .+1<CR>==',         { desc = "Move line down" })
vim.keymap.set('i', '<C-Up>',     "<Esc>:m .-2<CR>==gi",  { desc = "Move line up" })
vim.keymap.set('i', '<C-Down>',   "<Esc>:m .+1<CR>==gi",  { desc = "Move line down" })
vim.keymap.set('v', '<C-Up>',     ":m '<-2<CR>gv=gv",     { desc = "Move selection up" })
vim.keymap.set('v', '<C-Down>',   ":m '>+1<CR>gv=gv",     { desc = "Move selection down" })
-- indentation
vim.keymap.set('n', '<Tab>',      '>>',                   { desc = "Indent right" })
vim.keymap.set('n', '<S-Tab>',    '<<',                   { desc = "Indent left" })
vim.keymap.set('i', '<S-Tab>',    '<Esc> <<gi',           { desc = "Indent left" })
vim.keymap.set('v', '<Tab>',      '>gv',                  { desc = "Indent right" })
vim.keymap.set('v', '<S-Tab>',    '<gv',                  { desc = "Indent left" })

-- line duplication
vim.keymap.set({'n','v'}, '<C-d>', function()
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_put({line}, 'l', true, false)
end, { desc = "Duplicate line" })

vim.keymap.set('v', '<leader>d', function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, lines)
  vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
  vim.cmd("normal! V" .. (#lines - 1) .. "j")
end, { desc = "Duplicate selection" })

-- reload settings
vim.keymap.set('n', '<leader>rr', function()
  for name, _ in pairs(package.loaded) do
    if name:match('^config') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload nvim config" })
---- consider this if will configure autocmds:
-- local grp = vim.api.nvim_create_augroup("MyConfig", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", { group = grp, callback = set_picker_hl })
