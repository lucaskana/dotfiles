-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font({
	family = "JetBrains Mono",
	weight = "Medium",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" }, -- disable ligatures
})
config.font_size = 14.0
config.line_height = 1.0

-- config.enable_tab_bar = false
-- Tabs
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

config.color_scheme = "GruvboxDark"

config.window_background_opacity = 0.90
config.text_background_opacity = 0.90

-- ======================
-- ⌨️ Atalhos de teclado
-- ======================
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 3000 }
-- config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 3000 }
-- config.leader = { key = "Space", mods = "CTRL|SHIFT" }

config.keys = {
	-- Dividir panes
	{ key = "h", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Navegar entre panes
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },

	-- Gerenciar abas
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("DefaultDomain") },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },

	-- Copiar / Colar
	{ key = "y", mods = "LEADER", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "p", mods = "LEADER|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

	-- Modo fullscreen
	{ key = "f", mods = "LEADER", action = wezterm.action.ToggleFullScreen },
	{ key = "Enter", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen },
	{ key = "e", mods = "CMD", action = wezterm.action.QuickSelect },
	-- { key = "m", mods = "CTRL|SHIFT", action = wezterm.action.TogglePaneZoomState },
}

return config
