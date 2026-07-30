return {

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      -- https://github.com/nvim-lualine/lualine.nvim#default-configuration
      -- https://github.com/nvim-lualine/lualine.nvim#available-options
      require("lualine").setup({
        options  = {
          component_separators = {
            left = '',
            -- right = '',
          },
          section_separators = {
            left = '',
            right = '',
          },
        },
        sections = {
          lualine_x = {
            "encoding",
            "fileformat",
            "lsp_status",
            "filetype",
          },
        },
      })
    end
  },

}
