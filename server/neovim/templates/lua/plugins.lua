return {

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    -- https://github.com/nvim-telescope/telescope.nvim#pickers
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('telescope').setup({})
    end
  },

  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },

}
