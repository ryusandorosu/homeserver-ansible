return {

  { "neovim/nvim-lspconfig" },
 
  { "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
 
  { "williamboman/mason-lspconfig.nvim" },

  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    }
  },

  { "stevearc/conform.nvim" },

}
