return {

  {
    "folke/persistence.nvim",
    enabled = false,
    event = "BufReadPre",
    -- https://github.com/folke/persistence.nvim#-usage
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 1,
      branch = true,
    },
    -- dashboard.button("s", " " .. " Restore session in current directory", "<cmd> lua require('persistence').load() <cr>"),
    -- dashboard.button("a", " " .. " Saved sessions", "<cmd> lua require('persistence').select() <cr>"),
  },

  {
    "stevearc/resession.nvim",
    enabled = true,
    event = "BufReadPre",
    opts = {},
    config = function()
      local resession = require("resession")
      resession.setup({
        dir = "resession",
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          -- Create one session per directory
          resession.save(vim.fn.getcwd())
          -- Save a special session named "last"
          resession.save("last", { notify = false })
        end,
      })

    end,
  },

}
