return {

  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        -- https://github.com/nvimdev/dashboard-nvim#configuration
      }
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
  },

}
