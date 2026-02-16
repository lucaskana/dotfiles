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

-- my coolnight colorscheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.window_decorations = "RESIZE"

-- ======================
-- 🎨 Aparência
-- ======================
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.90
config.text_background_opacity = 0.90

-- ======================
-- ⌨️ Atalhos de teclado
-- ======================
-- config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 3000 }
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 3000 }
-- config.leader = { key = "Space", mods = "CTRL|SHIFT" }

config.keys = {
	-- Dividir panes
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

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
}

return config
