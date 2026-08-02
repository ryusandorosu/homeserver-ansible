return {

  {
    "nvim-mini/mini.pairs",
    enabled = false,
    version = '*',
    event = "VeryLazy",
    -- https://www.lazyvim.org/plugins/coding#minipairs
    opts = {
      modes = {
        insert = true,
        command = true,
        terminal = false,
      },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  },

}
