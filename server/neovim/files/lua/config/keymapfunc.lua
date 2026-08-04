-- window-picker
vim.keymap.set('n', '<leader>w',
function()
  local window_id = require('window-picker').pick_window()
  vim.api.nvim_set_current_win(window_id)
end,
{ desc = "Pick window" })

-- line duplication
vim.keymap.set({'n','v'}, '<C-d>',
function()
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_put({line}, 'l', true, false)
end,
{ desc = "Duplicate line" })

vim.keymap.set('v', '<leader>d',
function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, lines)
  vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
  vim.cmd("normal! V" .. (#lines - 1) .. "j")
end,
{ desc = "Duplicate selection" })

-- reload settings
vim.keymap.set('n', '<leader>rr',
function()
  for name, _ in pairs(package.loaded) do
    if name:match('^config') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end,
{ desc = "Reload nvim config" })
---- consider this if will configure autocmds:
-- local grp = vim.api.nvim_create_augroup("MyConfig", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", { group = grp, callback = set_picker_hl })

-- input named session saving
vim.keymap.set('n', '<C-s>',
function()
  require("resession").save(
    vim.ui.input(
      {
        prompt = "Session name: ",
        default = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      },
      function(name)
        if not name or name == "" then
          return
        end
        require("resession").save(name)
      end
    )
  ) 
end,
{ desc = "Save current session" })
