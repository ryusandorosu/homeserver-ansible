-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
-- local config = wezterm.config_builder()
local config = {}
config.initial_cols = 120
config.initial_rows = 28
config.font_size = 10
config.font = wezterm.font 'JetBrains Mono'
config.default_prog = { 'ssh', 'nuc' }

-- Finally, return the configuration to wezterm:
return config
