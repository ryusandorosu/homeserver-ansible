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
      -- Always save a special session named "last"
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          resession.save("last")
        end,
      })

      -- Create one session per directory
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args and without reading from stdin
          if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
          end
        end,
        nested = true,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
        end,
      })
      vim.api.nvim_create_autocmd('StdinReadPre', {
        callback = function()
          -- Store this for later
          vim.g.using_stdin = true
        end,
      })

    end,
  },

}
