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
          lualine_c = {
            {
              "filename",
              path = 4,
              file_status = true,
              new_file_status = true,
            },
          },
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

  {
    "kdheepak/tabline.nvim",
    dependencies = {
      { "hoob3rt/lualine.nvim", opt = true },
      { "kyazdani42/nvim-web-devicons", opt = true },
    },
    -- https://github.com/kdheepak/tabline.nvim#installation
    config = function()
      require("tabline").setup {
        enable = true,
        options = {
          max_bufferline_percent = 66,
          show_tabs_always = false,
          show_devicons = true,
          show_bufnr = false,
          show_filename_only = true,
          modified_italic = false,
          show_tabs_only = false,
        }
      }
      vim.cmd[[
        set guioptions-=e " Use showtabline in gui vim
        set sessionoptions+=tabpages,globals " store tabpages and globals in session
      ]]
    end,
  },

  {
    "willothy/nvim-cokeline",
    enabled = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/resession.nvim",
    },
    -- https://github.com/willothy/nvim-cokeline#wrench-configuration
    config = true
  },

}
