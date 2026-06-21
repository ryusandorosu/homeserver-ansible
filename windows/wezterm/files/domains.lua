local wezterm = require 'wezterm'
local domains = wezterm.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")
local config = {}
domains.apply_to_config(config, {
  keys = {
    attach = { key = 't', mods = 'CTRL' },
    hsplit = { key  = 'h', mods = 'CTRL' },
    vsplit = {},
  }
})
return domains
