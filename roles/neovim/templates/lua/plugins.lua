return {

  { "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end
  },
  
  { "tpope/vim-fugitive" },

  { "airblade/vim-gitgutter" },

  { "nvim-treesitter/nvim-treesitter", build=":TSUpdate" },
 
}
 