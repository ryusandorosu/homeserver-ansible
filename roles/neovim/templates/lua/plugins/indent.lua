return {
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local hooks = require("ibl.hooks")
      hooks.register(
        hooks.type.SCOPE_HIGHLIGHT,
        hooks.builtin.scope_highlight_from_extmark
      )
      require("ibl").setup({
        scope = {
          show_exact_scope = true,
          highlight = {
            "Function",
            "Label",
            "IblScope",
          },
        },
      })
    end
  },

}
