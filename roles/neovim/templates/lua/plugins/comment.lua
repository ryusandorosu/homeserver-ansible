return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local api = require("Comment.api")
      vim.keymap.set({'i', 'n'}, '<leader>/', function()
        api.toggle.linewise.current()
      end)
      vim.keymap.set('v', '<leader>/', function()
        api.toggle.linewise(vim.fn.visualmode())
      end)
    end
  }
}
