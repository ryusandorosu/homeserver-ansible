local wezterm = require 'wezterm'
local module = {}
function module.applyconfig(config)
  wezterm.plugin
  .require 'https://github.com/koh-sh/wezterm-theme-rotator'
  .apply_to_config(config, {
    -- Customize "Next Theme" key
    next_theme_key = 'n',
    next_theme_mods = 'SUPER|SHIFT',
    -- Customize "Previous Theme" key
    prev_theme_key = 'p',
    prev_theme_mods = 'SUPER|SHIFT',
    -- Customize "Random Theme" key
    random_theme_key = 'r',
    random_theme_mods = 'SUPER|SHIFT',
    -- Customize "Default Theme" key
    default_theme_key = 'd',
    default_theme_mods = 'SUPER|SHIFT',
  })
end
return module
