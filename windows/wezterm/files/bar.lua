local wezterm = require 'wezterm'
local module = {}
function module.applyconfig(config)
  wezterm.plugin
  .require("https://github.com/adriankarlen/bar.wezterm")
  .apply_to_config(config, {
    position = "top",
    modules = {
      tabs = {
        inactive_tab_fg = 8,
        new_tab_fg = 8,
      },
      workspace = { enabled = false },
      ssh = { enabled = true },
      username = { color = 8 },
      clock = { format = "%H:%M:%S" },
    },
  })
end
return module
