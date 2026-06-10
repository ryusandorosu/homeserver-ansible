return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>')
    end
  },

  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require("nvim-tree").setup({
  --       view = { width = 30 },
  --       filters = { dotfiles = false },
  --       git = { enable = true },
  --       actions = {
  --         open_file = {
  --           quit_on_open = true, -- закроет дерево после открытия файла
  --         },
  --       },
  --       -- авто-закрытие при последнем буфере
  --       -- только если включена эта настройка:
  --       hijack_netrw = true,
  --     })
  --   end,
  -- },

  {
    "antosha417/nvim-lsp-file-operations",
    config = function()
      require("lsp-file-operations").setup()
    end
  },

  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup()
    end
  },
}
