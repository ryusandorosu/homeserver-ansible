return {

  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  { "RRethy/vim-illuminate" },

  {
    "folke/trouble.nvim",
    -- https://github.com/folke/trouble.nvim#setup
    -- https://www.lazyvim.org/plugins/editor#troublenvim
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    cmd = "Trouble",
    -- https://github.com/folke/trouble.nvim#telescope
    -- https://github.com/folke/trouble.nvim#statusline-component
  },

  -- https://github.com/folke/edgy.nvim -- to make ide-like layouts -- https://www.lazyvim.org/extras/ui/edgy
  -- https://nvimdev.github.io/lspsaga/
  -- https://github.com/stevearc/aerial.nvim -- https://github.com/hedyhli/outline.nvim
  -- https://github.com/nvim-mini/mini.move
  -- https://github.com/ThePrimeagen/refactoring.nvim
  -- https://github.com/gbprod/yanky.nvim

}
