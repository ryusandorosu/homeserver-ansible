return {

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

  {
    "kdheepak/tabline.nvim",
    dependencies = {
      { 'hoob3rt/lualine.nvim', opt = true },
      { 'kyazdani42/nvim-web-devicons', opt = true },
    },
    -- https://github.com/kdheepak/tabline.nvim#installation
    config = function()
      require'tabline'.setup {
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

}
