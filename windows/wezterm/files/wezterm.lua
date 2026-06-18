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
-- most preferred themes
config.color_scheme = 'Tango (terminal.sexy)'
-- config.color_scheme = 'Orangish (terminal.sexy)'
-- config.color_scheme = 'Muse (terminal.sexy)'
-- also ok themes
-- config.color_scheme = 'Red Alert'
-- config.color_scheme = 'Red Sands'
-- config.color_scheme = 'Konsolas'
-- config.color_scheme = 'Iiamblack (terminal.sexy)'
-- config.color_scheme = 'Digerati (terminal.sexy)'
-- config.color_scheme = 'Hurtado'
-- config.color_scheme = 'Ibm3270 (Gogh)'
-- config.color_scheme = 'NightLion v1'
-- config.color_scheme = 'Numix Darkest (terminal.sexy)'
-- config.color_scheme = 'Seti'
-- config.color_scheme = 'Sundried'

-- Finally, return the configuration to wezterm:
return config
