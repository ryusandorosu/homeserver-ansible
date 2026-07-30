return {

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

}
