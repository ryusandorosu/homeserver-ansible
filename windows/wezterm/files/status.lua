local wezterm = require 'wezterm'
local status = wezterm.plugin.require('https://github.com/yriveiro/wezterm-status')
local config = {}
status.apply_to_config(config, {
  ui = {
    theme = {
      bg_color = '#202020',
      fg_color = '#646464',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    separators = {
      arrow_solid_left = '',
      arrow_solid_right = '',
      arrow_thin_left = '',
      arrow_thin_right = ' ',
    },
  },
  cells = {
    workspace = { enabled = false },
    mode = { enabled = true },
    hostname = { enabled = true },
    cwd = {
      enabled = true,
      tilde_prefix = false,
    },
    date = {
      enabled = true,
      format = '%H:%M:%S',
      icon = '',
    },
    battery = { enabled = true },
  },
})
return status
