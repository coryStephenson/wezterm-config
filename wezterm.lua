-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- max fps
config.max_fps = 240
config.animation_fps = 240

--[[
============================
Custom Configuration
============================
]] --

-- Rounded or Square Style Tabs

-- change to square if you don't like rounded tab style
local tab_style = "square"

-- leader active indicator prefix
local leader_prefix = utf8.char(0x1f30a) -- ocean wave


--[[
============================
Font
============================
]] --

config.font = 
    wezterm.font("JetBrains Mono", { weight = "Bold" })

--[[
============================ 
Window
============================
]] --

config.window_decorations = "RESIZE" -- disable the title bar 
                                     -- but enable the resizable border
config.enable_tab_bar = true
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.default_cursor_style = "BlinkingBar"
config.background = {
        {
            source = {
                File = "/usr/share/wallpapers/Cone_Nebula.jpg",
            },
            hsb = {
                hue = 1.0,
                saturation = 1.02,
                brightness = 0.25,
            },
            width = "100%",
            height = "100%",
        },
        {
            source = {
                Color = "#282c35",
            },
            width = "100%",
            height = "100%",
            opacity = 0.55,
        },
    }

--[[
============================ 
Colors
============================ 
]] --

config.color_scheme = "Nancy (terminal.sexy)"

-- color_scheme not sufficient in providing available colors
-- local colors = wezterm.color.get_builtin_schemes()[color_scheme]

-- color scheme colors for easy access
local scheme_colors = {
    terminalsexy = {
        nancy = {
           darkblack = "#1b1d1e",
           magenta = "#f92672",
           lime = "#82b414",
           orange = "#fd971f",
           steelblue = "#4e82aa",
           violet = "#8c54fe",
           cyan = "#465457",
           lightgray = "#ccccc6",
           mediumgray = "#505354",
           brightred = "#ff5995",
           brightgreen = "#b6e354",
           brightyellow = "#feed6c",
           brightblue = "#0c73c2",
           brightpurple = "#9e6ffe",
           brightcyan = "#899ca1",
           cream = "#f8f8f2",
           foreground = "#ffffff",
           background = "#010101"
        }
    }
}

local colors = {
    border = scheme_colors.terminalsexy.nancy.brightpurple,
    tab_bar_active_tab_fg = scheme_colors.terminalsexy.nancy.orange,
    tab_bar_active_tab_bg = scheme_colors.terminalsexy.nancy.cream,
    tab_bar_text = scheme_colors.terminalsexy.nancy.cream,
    arrow_foreground_leader = scheme_colors.terminalsexy.nancy.brightpurple,
    arrow_background_leader = scheme_colors.terminalsexy.nancy.cream,
}



--[[
============================
Border
============================
]] --

config.window_frame = {
    border_left_width = "0.4cell",
    border_right_width = "0.4cell",
    border_bottom_height = "0.15cell",
    border_top_height = "0.15cell",
    border_left_color = colors.border,
    border_right_color = colors.border,
    border_bottom_color = colors.border,
    border_top_color = colors.border, 
}

--[[
============================
Shortcuts
============================
]] --

-- shortcut_configuration
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab "CurrentPaneDomain",
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },
    {
        mods = "LEADER",
        key = "b",
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
        mods = "LEADER",
        key = "v",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "-",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "h",
        action = wezterm.action.ActivatePaneDirection "Left"
    },
    {
        mods = "LEADER",
        key = "j",
        action = wezterm.action.ActivatePaneDirection "Down"
    },
    {
        mods = "LEADER",
        key = "k",
        action = wezterm.action.ActivatePaneDirection "Up"
    },
    {
        mods = "LEADER",
        key = "l",
        action = wezterm.action.ActivatePaneDirection "Right"
    },
    {
        mods = "LEADER",
        key = "LeftArrow",
        action = wezterm.action.AdjustPaneSize { "Left", 5 }
    },
    {
        mods = "LEADER",
        key = "RightArrow",
        action = wezterm.action.AdjustPaneSize { "Right", 5 }
    },
    {
        mods = "LEADER",
        key = "DownArrow",
        action = wezterm.action.AdjustPaneSize { "Down", 5 }
    },
    {
        mods = "LEADER",
        key = "UpArrow",
        action = wezterm.action.AdjustPaneSize { "Up", 5 }
    },
}

for i = 0, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i),
    })
end

--[[
============================
Tab Bar
============================
]] --

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

wezterm.on(
    "format-tab-title",
    function(tab, tabs, panes, config, hover, max_width)
        local title = " " .. tab.tab_index .. ": " .. tab_title(tab) .. " "
        local left_edge_text = ""
        local right_edge_text = ""

        if tab_style == "rounded" then
            title = tab.tab_index .. ": " .. tab_title(tab)
            title = wezterm.truncate_right(title, max_width - 2)
            left_edge_text = wezterm.nerdfonts.ple_left_half_circle_thick
            right_edge_text = wezterm.nerdfonts.ple_right_half_circle_thick
        end

        -- ensure that the titles fit in the available space,
        -- and that we have room for the edges.
        -- title = wezterm.truncate_right(title, max_width - 2)

        if tab.is_active then
            return {
                { Background = { Color = colors.tab_bar_active_tab_bg } },
                { Foreground = { Color = colors.tab_bar_active_tab_fg } },
                { Text = left_edge_text },
                { Background = { Color = colors.tab_bar_active_tab_fg } },
                { Foreground = { Color = colors.tab_bar_text } },
                { Text = title },
                { Background = { Color = colors.tab_bar_active_tab_bg } },
                { Foreground = { Color = colors.tab_bar_active_tab_fg } },
                { Text = right_edge_text },
            }
        else
            -- Inactive tab formatting
            return {
                { Background = { Color = colors.tab_bar_active_tab_bg } },
                { Foreground = { Color = colors.tab_bar_text } },
                { Text = left_edge_text },
                { Background = { Color = scheme_colors.terminalsexy.nancy.darkblack } },
                { Foreground = { Color = scheme_colors.terminalsexy.nancy.mediumgray } },
                { Text = title },
                { Background = { Color = colors.tab_bar_active_tab_bg } },
                { Foreground = { Color = scheme_colors.terminalsexy.nancy.darkblack } },
                { Text = right_edge_text },
            }
        end
    end
)

--[[
============================
Leader Active Indicator
============================
]] --

wezterm.on("update-status", function(window, _)
    -- leader inactive
    local solid_left_arrow = ""
    local arrow_foreground = { Foreground = { Color = colors.arrow_foreground_leader } }
    local arrow_background = { Background = { Color = colors.arrow_background_leader } }
    local prefix = ""

    -- leaader is active
    if window:leader_is_active() then
        prefix = " " .. leader_prefix

        if tab_style == "rounded" then
            solid_left_arrow = wezterm.nerdfonts.ple_right_half_circle_thick
        else
            solid_left_arrow = wezterm.nerdfonts.pl_left_hard_divider
        end

        local tabs = window:mux_window():tabs_with_info()

        if tab_style ~= "rounded" then
            for _, tab_info in ipairs(tabs) do
                if tab_info.is_active and tab_info.index == 0 then
                    arrow_background = { Foreground = { Color = colors.tab_bar_active_tab_fg } }
                    solid_left_arrow = wezterm.nerdfonts.pl_right_hard_divider
                    break
                end
            end
        end
    end


    window:set_left_status(wezterm.format {
        { Background = { Color = colors.arrow_foreground_leader } },
        { Text = prefix },
        arrow_foreground,
        arrow_background,
        { Text = solid_left_arrow }
    })
end)

-- and finally, return the configuration to wezterm
return config

