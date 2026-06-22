local wezterm = require 'wezterm'
local module = {}
function module.applyconfig(config)
  wezterm.plugin
  .require("https://github.com/DavidRR-F/quick_domains.wezterm")
  .apply_to_config(config, {
    keys = {
      attach = { key = 't', mods = 'CTRL' },
      hsplit = { key  = 'h', mods = 'CTRL' },
      vsplit = { key  = 'v', mods = 'ALT' },
    }
  })
end
return module
