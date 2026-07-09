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
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({})
    end
  },

  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },

}
