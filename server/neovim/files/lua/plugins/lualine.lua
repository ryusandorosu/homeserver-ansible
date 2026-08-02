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
            right = '',
          },
          section_separators = {
            left = '',
            right = '',
          },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {
            {
              "filename",
              path = 3,
              file_status = true,
              new_file_status = true,
            },
          },
          lualine_x = {
            { "encoding", show_bomb = true },
            { "fileformat", separator = ' ' },
            {
              "lsp_status",
              icon = '',
              symbols = {
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                done = '✓',
              },
              ignore_lsp = {},
              show_name = true,
            },
            "filetype",
          },
          lualine_y = {'progress'},
          lualine_z = {'location'},
        },
        tabline = {
          lualine_a = {
            {
              "buffers",
              mode = 2,
              show_filename_only = true,
              hide_filename_extension = true,
              use_mode_colors = true,
            },
          },
          lualine_y = {
            {
              "tabs",
              mode = 0,
              use_mode_colors = true,
            },
          },
          lualine_z = {
            {
              "windows",
              mode = 0,
              use_mode_colors = true,
            },
          },
        },
      })
    end
  },

  {
    "kdheepak/tabline.nvim",
    dependencies = {
      { "nvim-lualine/lualine.nvim", opt = true },
      { "nvim-tree/nvim-web-devicons", opt = true },
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
