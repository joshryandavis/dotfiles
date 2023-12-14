-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 0,
}

config.font = wezterm.font({
  family = "JetBrains Mono",
  -- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})

config.font_size = 16.0

config.window_close_confirmation = "NeverPrompt"
config.keys = {
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
}

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

custom.background = "#000000"
custom.tab_bar.background = "#040404"
custom.tab_bar.inactive_tab.bg_color = "#0f0f0f"
custom.tab_bar.new_tab.bg_color = "#080808"

config.color_schemes = {
  ["OLEDppuccin"] = custom,
}
config.color_scheme = "OLEDppuccin"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
-- and finally, return the configuration to wezterm
return config
