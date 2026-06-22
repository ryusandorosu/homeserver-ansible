local wezterm = require("wezterm")
local act = wezterm.action
local module = {}
function module.applyconfig(config)
  wezterm.plugin
  .require("https://github.com/abidibo/wezterm-sessions")
  .apply_to_config(config, {
    auto_save_interval_s = 300,
    git_branch_warn = true,
    keys = {
      {
        key = 's',
        mods = 'ALT',
        action = act({ EmitEvent = "save_session" }),
      },
      {
        key = 'l',
        mods = 'ALT',
        action = act({ EmitEvent = "load_session" }),
      },
      {
        key = 'r',
        mods = 'ALT',
        action = act({ EmitEvent = "restore_session" }),
      },
      {
        key = 'd',
        mods = 'CTRL|SHIFT',
        action = act({ EmitEvent = "delete_session" }),
      },
        {
        key = 'a',
        mods = 'ALT',
        action = act({ EmitEvent = "toggle_autosave" }),
      },
      {
        key = 'e',
        mods = 'CTRL|SHIFT',
        action = act({ EmitEvent = "edit_session" }),
      },
      {
        key = 'f',
        mods = 'ALT',
        action = act({ EmitEvent = "fork_session" }),
      },
    }
  })
end
return module
