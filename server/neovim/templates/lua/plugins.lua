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

  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },
  -- https://nvimdev.github.io/lspsaga/

}
