local wez_status, wezterm = pcall(require, "wezterm")
if not wez_status then
  return {}
end

local act = wezterm.action

-- local ssh_domains = require("user.ssh")

return {
  front_end = "WebGpu", -- ensure use of Metal on MacOS
  -- The below does not work properly with nix-based fish.
  default_prog = { "/Users/david/.nix-profile/bin/fish", "-l" },
  color_scheme = "Catppuccin Latte",
  -- font = wezterm.font("SFMono Nerd Font"),
  font = wezterm.font_with_fallback({
    "IosevkaTerm Nerd Font",
    "JetBrainsMono Nerd Font",
    "Maple Mono", -- "Maple Mono NF",
    "FiraMono Nerd Font",
    "JetBrains Mono",
    "SFMono Nerd Font",
    -- "SauceCodePro Nerd Font",
    -- "MesloLGS NF",
  }),
  font_size = 16,
  window_background_opacity = 1,
  window_decorations = "RESIZE",

  window_padding = {
    left = "1cell",
    right = "1cell",
    top = 20,
    bottom = 0,
  },

  audible_bell = "Disabled",
  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
  },
  colors = {
    visual_bell = "#202020",
  },

  -- Tab bar
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,

  -- ssh_domains = ssh_domains,
  inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.90,
  },

  keys = {
    -- Pane keymaps
    { key = "s", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "v", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "n", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
    { key = "i", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
    { key = "u", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
    { key = "e", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
    { key = "r", mods = "CTRL|SHIFT", action = act.RotatePanes("Clockwise") },
  },
}
