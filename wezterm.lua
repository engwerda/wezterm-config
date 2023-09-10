local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

wezterm.on('gui-startup', function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.color_scheme = "JetBrains Darcula"
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12
config.line_height = 1
config.harfbuzz_features = {"cv29", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07"}
config.use_dead_keys = false
config.show_update_window = true
config.exit_behavior = "Close"
config.window_close_confirmation = "NeverPrompt"
config.unicode_version = 14

-- Check the host operating system
if wezterm.target_triple:match("linux") then
  -- You are on Linux, no need to set a specific domain for WSL
  config.default_domain = nil
elseif wezterm.target_triple:match("windows") then
  -- You are on Windows, set the default domain for WSL
  config.default_domain = "WSL:Ubuntu-22.04"
end


-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 10000
-- Enable the scrollbar.
-- It will occupy the right window padding space.
-- If right padding is set to 0 then it will be increased
-- to a single cell width
config.enable_scroll_bar = true


config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.5,
}

-- Initializing the keys table
config.keys = {}

-- Inserting keybindings for numbers
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "ALT",
    action = act({ ActivateTab = i - 1 }),
  })
end

-- Inserting other keybindings
local keybindings = {
  { key = "v", mods = "CTRL",       action = act.PasteFrom("Clipboard") },
  { key = "n", mods = "ALT",        action = act.SpawnTab("CurrentPaneDomain") },
  { key = "v", mods = "ALT",        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "s", mods = "ALT",        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
  { key = "8", mods = "CTRL",       action = act.PaneSelect },
  { key = "h", mods = "ALT",        action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "ALT",        action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "ALT",        action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "ALT",        action = act.ActivatePaneDirection("Down") },
  { key = "j", mods = "ALT|SHIFT",  action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "k", mods = "ALT|SHIFT",  action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "h", mods = "ALT|SHIFT",  action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "l", mods = "ALT|SHIFT",  action = act.AdjustPaneSize({ "Right", 5 }) },
}

for _, binding in ipairs(keybindings) do
  table.insert(config.keys, binding)
end

config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font({ family = "Roboto", weight = "Bold" }),

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 12.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = "#333333",

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = "#333333",
}

config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = "#575757",
  },
}

-- and finally, return the configuration to wezterm
return config
