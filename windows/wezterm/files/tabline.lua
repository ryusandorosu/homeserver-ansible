local wezterm = require 'wezterm'
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    theme = 'Abernathy',
  },
-- config.color_scheme = 'Abernathy'
-- config.color_scheme = 'Adventure'
  sections = {
    tabline_a = { 'hostname' }, --mode
    tabline_b = { 'domain' }, --workspace
    tabline_x = { {'ram', use_pwsh = true}, {'cpu', use_pwsh = true} },
    tabline_y = {}, -- 'hostname', 'domain'
    tabline_z = { 'battery', {'datetime', style = '%H:%M:%S'} },
  },
})
return tabline
--does not work with tab_bar_at_bottom = true
