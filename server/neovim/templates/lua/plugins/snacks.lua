return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard =     {
        -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
        enabled = true
      },
      explorer =      { enabled = true },
      picker =        {
        enabled = true,
        -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-layouts
        -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#files
        hidden  = true,
      },
    },
    -- suggested keymaps are listed here: https://github.com/folke/snacks.nvim#-usage
  }
}
