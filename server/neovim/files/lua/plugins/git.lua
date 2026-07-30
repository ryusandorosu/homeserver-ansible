return {
  -- https://www.lazyvim.org/plugins/editor#gitsignsnvim
  -- https://github.com/lewis6991/gitsigns.nvim#%EF%B8%8F-installation--usage
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 1500,
      },
    }
  },

}
