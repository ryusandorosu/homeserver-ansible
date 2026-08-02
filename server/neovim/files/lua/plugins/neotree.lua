return {

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    -- https://github.com/nvim-neo-tree/neo-tree.nvim#configuration
    opts = {
      close_if_last_window = false,
      default_component_configs = {
        modified = {
          symbol = "",
          highlight = "NeoTreeModified",
        },
      },
      window = {
        position = "left",
        mappings = {
          ["s"] = "open_split",
          ["h"] = "open_vsplit",
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_ignored = true,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
      },
    },
  },

  {
    "antosha417/nvim-lsp-file-operations",
    config = function()
      require("lsp-file-operations").setup()
    end
  },

  -- neotree alternatives:

  {
    "ms-jpq/chadtree",
    enabled = false,
    build=":CHADdeps",
    -- vim.keymap.set('n', '<leader><space>',  ':CHADopen <CR>',  { desc = "ChadTree" }),
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    opts = {
      -- vim.keymap.set('n', '<leader><space>',  ':NvimTreeOpen <CR>',  { desc = "NvimTree" }),
    }
  },

}
