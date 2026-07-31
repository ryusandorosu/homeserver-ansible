return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- https://github.com/folke/which-key.nvim#-triggers
    -- https://www.lazyvim.org/plugins/editor#which-keynvim
    opts = {
      preset = "modern",
      delay = 2500,
      expand = 1,
    },
  },
}
