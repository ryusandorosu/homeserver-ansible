return {

  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  -- { "tpope/vim-fugitive" }, -- disable it
  -- { "airblade/vim-gitgutter" }, -- gitsigns is much faster

  -- https://github.com/lewis6991/gitsigns.nvim -- https://www.lazyvim.org/plugins/editor#gitsignsnvim
  { "lewis6991/gitsigns.nvim" },

  { "RRethy/vim-illuminate" },

  -- https://github.com/folke/edgy.nvim -- to make ide-like layouts -- https://www.lazyvim.org/extras/ui/edgy
  -- https://nvimdev.github.io/lspsaga/
  -- https://github.com/stevearc/aerial.nvim -- https://github.com/hedyhli/outline.nvim
  -- https://github.com/nvim-mini/mini.move
  -- https://github.com/ThePrimeagen/refactoring.nvim
  -- https://github.com/gbprod/yanky.nvim

}
