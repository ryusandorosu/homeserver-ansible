-- :help default-mappings
-- :h nvim-surround.configuration -- default is 'S' when selected in visual mode
-- :h comment.config -- default is 'gc'(nv) - opleader and 'gcc'(n) - toggler for selected lines. redefined to 'c' and 'cc'
-- ctrl-q and button: <key>; <cr> = enter, <cmd> = ':'
vim.g.mapleader = " "
vim.keymap.set('n', '<C-w>', ':w<CR>', { desc = "Save the file" })
vim.keymap.set('n', '<C-x>', ':q<CR>', { desc = "Close current window" })
vim.keymap.set({'n','v'}, '<C-a>', 'ggVG', { desc = "Select all text" })
vim.keymap.set('i', '<C-a>', '<Esc>ggVG', { desc = "Select all text" })
vim.keymap.set('n', '<leader>h', ':split<CR>', { desc = "Horizontal split" })
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = "Vertical split" })

-- neotree
vim.keymap.set('n', '<C-n>', ':Neotree <CR>')
vim.keymap.set('n', '<C-Right>', ':bnext<CR>') --<leader><Right>
vim.keymap.set('n', '<C-Left>', ':bprevious<CR>') --<leader><Left>

-- telescope
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fw', ':Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>')

-- line moving
vim.keymap.set('n', '<C-Up>', ':m .-2<CR>==', { desc = "Move line up" })
vim.keymap.set('n', '<C-Down>', ':m .+1<CR>==', { desc = "Move line down" })
vim.keymap.set('i', '<C-Up>', "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
vim.keymap.set('i', '<C-Down>', "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set('v', '<C-Up>', ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set('v', '<C-Down>', ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
-- indentation
vim.keymap.set('n', '<Tab>', '>>')
vim.keymap.set('n', '<S-Tab>', '<<')
vim.keymap.set('i', '<S-Tab>', '<Esc> <<gi')
vim.keymap.set('v', '<Tab>', '>gv')
vim.keymap.set('v', '<S-Tab>', '<gv')

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
