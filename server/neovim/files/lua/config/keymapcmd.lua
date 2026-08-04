vim.g.mapleader = " " -- <leader> = <space>
-- :h nvim-surround.configuration -- default is 'S' when selected in visual mode
-- :h comment.config -- default is 'gc'(nv) - opleader and 'gcc'(n) - toggler for selected lines. redefined to 'c' and 'cc'
-- REMINDER: ctrl-q (by default) and button: returns <key>; <cr> = enter, <cmd> = ':'

vim.keymap.set('n',       '<esc><esc>',       ':Alpha <CR>',                      { desc = "Toggle dashboard" })
vim.keymap.set('n',       '<leader><space>',  ':Neotree <CR>',                    { desc = "Neotree" })
vim.keymap.set('n',       '<C-w>',            ':w<CR>',                           { desc = "Save the file" })
-- closing
vim.keymap.set('n',       '<C-q>',            ':q<CR>',                           { desc = "Close current window" })
vim.keymap.set('n',       '<C-x>',            ':qa!<CR>',                         { desc = "Close all windows!" })
vim.keymap.set('n',       '<leader>q',        ':bdelete<CR>',                     { desc = "Close current buffer" })
-- selection
vim.keymap.set({'n','v'}, '<C-a>',            'ggVG',                             { desc = "Select all text" })
vim.keymap.set('i',       '<C-a>',            '<Esc>ggVG',                        { desc = "Select all text" })
-- split window
vim.keymap.set('n',       '<leader>h',        ':split<CR>',                       { desc = "Horizontal split" })
vim.keymap.set('n',       '<leader>v',        ':vsplit<CR>',                      { desc = "Vertical split" })

-- window-picker
vim.keymap.set('n',       '<leader><Tab>',    '<C-w>w',                           { desc = "Cycle windows" })
vim.keymap.set('n',       '<leader><Right>',  ':bnext<CR>',                       { desc = "Switch to next buffer" })
vim.keymap.set('n',       '<leader><Left>',   ':bprevious<CR>',                   { desc = "Switch to previous buffer" })

-- telescope
vim.keymap.set('n',       '<leader>b',        ':Telescope buffers<cr>')
vim.keymap.set('n',       '<leader>cc',       ':Telescope commands<cr>')
vim.keymap.set('n',       '<leader>c',        ':Telescope command_history<cr>')
vim.keymap.set('n',       '<leader>k',        ':Telescope keymaps<cr>',           { desc = "Telescoped :help default-mappings"})
vim.keymap.set('n',       '<leader>kk',       ':checkhealth which-key<cr>',       { desc = "Show overlapping keymaps"})
vim.keymap.set('n',       '<leader>g',        ':Gitsigns<cr>')
-- trouble
vim.keymap.set('n',       '<leader>e',        ':Trouble<cr>',                     { desc = "Trouble plugin menu to inspect errors" })
vim.keymap.set('n',       '<leader>ed',       ':Trouble diagnostics toggle<cr>',  { desc = "Toggle Trouble diagnostics" })

-- line moving
vim.keymap.set('n',       '<A-Up>',           ':m .-2<CR>==',                     { desc = "Move line up" })
vim.keymap.set('n',       '<A-Down>',         ':m .+1<CR>==',                     { desc = "Move line down" })
vim.keymap.set('i',       '<A-Up>',           "<Esc>:m .-2<CR>==gi",              { desc = "Move line up" })
vim.keymap.set('i',       '<A-Down>',         "<Esc>:m .+1<CR>==gi",              { desc = "Move line down" })
vim.keymap.set('v',       '<A-Up>',           ":m '<-2<CR>gv=gv",                 { desc = "Move selection up" })
vim.keymap.set('v',       '<A-Down>',         ":m '>+1<CR>gv=gv",                 { desc = "Move selection down" })
-- indentation
vim.keymap.set('n',       '<Tab>',            '>>',                               { desc = "Indent right" })
vim.keymap.set('n',       '<S-Tab>',          '<<',                               { desc = "Indent left" })
vim.keymap.set('i',       '<Tab><Tab>',       '<Esc> >>gi',                       { desc = "Indent right" })
vim.keymap.set('i',       '<S-Tab>',          '<Esc> <<gi',                       { desc = "Indent left" })
vim.keymap.set('v',       '<Tab>',            '>gv',                              { desc = "Indent right" })
vim.keymap.set('v',       '<S-Tab>',          '<gv',                              { desc = "Indent left" })

-- useful for debugging
vim.keymap.set('n',       '<leader>i',        ':Inspect<cr>',                     { desc = "Inspect element under cursor" })
