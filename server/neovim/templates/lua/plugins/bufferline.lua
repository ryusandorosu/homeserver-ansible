return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local bufferline = require('bufferline')
      require("bufferline").setup({
        -- :h bufferline-configuration
        -- :h bufferline-styling
        options = {
          mode = "buffers",
          separator_style = "thick",
          style_preset = bufferline.style_preset.no_italic
        }
      })
    end,
  },

}
