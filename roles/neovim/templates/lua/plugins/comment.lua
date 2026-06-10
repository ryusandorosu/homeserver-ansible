return {
  {
    "numToStr/Comment.nvim",
    config = function()
      -- https://github.com/numToStr/Comment.nvim#setup
      require("Comment").setup({
        opleader = { line = 'c' }, --normal, visual
        toggler = { line = 'cc' }, --normal
      })
      local api = require("Comment.api")
      vim.keymap.set({'i', 'n'}, '<leader>/', function()
        api.toggle.linewise.current()
      end)
    end
  }
}
