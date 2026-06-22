local wezterm = require 'wezterm'
local module = {}
function module.applyconfig(config)
  wezterm.plugin
  .require("https://github.com/michaelbrusegard/tabline.wez")
  .setup({
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
end
return module
--does not work with tab_bar_at_bottom = true
