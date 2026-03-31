local wezterm = require("wezterm");
local config = wezterm.config_builder();

-- # STARTUP # --
config.default_prog = {
  "/run/current-system/sw/bin/zsh"
};

-- # FONT # --
config.font = wezterm.font("CaskaydiaCoveNerdFont");
config.font_size = 12.0;
config.line_height = 1.05;

-- # STYLE # --
config.window_background_opacity = 0.9;
config.hide_tab_bar_if_only_one_tab = true;
config.window_padding = {
  left   = 0;
  right  = 0;
  top    = 0;
  bottom = 0;
};

-- # BLUR # --
-- KDE Plasma
config.kde_window_background_blur = true;

-- # COLOR SCHEME # --
config.color_scheme = "Tokyo Night Moon";

-- # HOTKEYS # --
config.keys = {
};

return config
