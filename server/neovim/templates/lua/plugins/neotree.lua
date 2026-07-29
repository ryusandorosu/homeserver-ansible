-- https://github.com/nvim-tree/nvim-tree.lua -- base version
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    -- https://github.com/nvim-neo-tree/neo-tree.nvim#configuration
    require("neo-tree").setup({
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_ignored = true,
        }
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    })
  },

  {
    "antosha417/nvim-lsp-file-operations",
    config = function()
      require("lsp-file-operations").setup()
    end
  },

}
