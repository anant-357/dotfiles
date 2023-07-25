local dpi = require("beautiful.xresources").apply_dpi
local os = os
local gears = require("gears")
local functions = require("functions")
local wibar_widget_shape = functions.wi_widget_shape
local awful = require("awful")
local theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/"
theme.wallpaper = theme.dir .. "/wallpapers/monochrome-clouds.jpg"
theme.colors = require("colorschemes.monochrome.main")
theme.mode = theme.colors.dark

-- theme.font = "Iosevka 11"
theme.font = "Fira Code, Bold 11"
theme.fg_normal = theme.mode.fg0
theme.fg_focus = theme.mode.fg1
theme.fg_urgent = "#fb4934"
theme.useless_gap = dpi(15)
theme.layout_tile = gears.color.recolor_image(theme.dir .. "assets/layout/tile.png", theme.mode.light_orange)
theme.layout_floating = gears.color.recolor_image(theme.dir .. "assets/layout/floating.png", theme.mode.light_orange)
theme.layout_tile = gears.color.recolor_image(theme.dir .. "assets/layout/tile.png", theme.mode.light_orange)

theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = true
theme.bg_alt = theme.mode.bg1

-- Colors
theme.background = theme.mode.bg
theme.background_alt = theme.mode.bg0_h
theme.foreground = theme.mode.fg0
theme.primary = theme.mode.dark_orange
theme.secondary = theme.mode.dark_yellow
theme.alert = theme.mode.dark_red
theme.disabled = theme.mode.dark_gray

theme.notification_bg = theme.mode.bg
theme.notification_fg = theme.mode.fg
theme.tooltip_bg = theme.mode.bg
theme.tooltip_fg = theme.mode.fg
theme.tooltip_font = "Fira Code, Medium 10"
theme.tooltip_shape = wibar_widget_shape
theme.tooltip_border_color = theme.mode.fg1
theme.tooltip_border_width = dpi(3)
theme.border_width = dpi(0)
theme.border_normal = theme.mode.fg1
theme.border_focus = theme.mode.fg2
theme.border_marked = "#CC9393"

theme.user_image = theme.dir .. "assets/pfp.jpg"

theme.titlebar_close_button_normal = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png", theme.bg_alt)
theme.titlebar_close_button_focus = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_2.png",
    theme.mode.dark_red)

theme.titlebar_minimize_button_normal = gears.color.recolor_image(theme.dir .. "assets/titlebar/minimize_1.png",
    theme.bg_alt)
theme.titlebar_minimize_button_focus = gears.color.recolor_image(theme.dir .. "assets/titlebar/minimize_2.png",
    theme.mode.dark_green)

theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.bg_alt)
theme.titlebar_maximized_button_focus_inactive = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.mode.dark_yellow)
theme.titlebar_maximized_button_normal_active = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.bg_alt)
theme.titlebar_maximized_button_focus_active = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.mode.dark_yellow)

theme.arch_icon_bg = theme.mode.dark_purple
theme.arch_icon_fg = theme.mode.light_purple

theme.user_bg = theme.mode.bg

theme.mood_bg = theme.mode.bg
theme.mood_fg = theme.mode.fg
theme.mood_index = 2

theme.volume_bar_bg = theme.mode.bg
theme.volume_bar_real_bg = theme.mode.bg
theme.volume_bar_fg = theme.mode.fg

theme.brightness_bar_bg = theme.mode.bg
theme.brightness_bar_real_bg = theme.mode.bg
theme.brightness_bar_fg = theme.mode.fg

theme.spotify_bg = theme.mode.dark_green
theme.spotify_fg = theme.mode.light_green

theme.webcam_bg = theme.mode.dark_gray
theme.volume_bg = theme.mode.dark_gray
theme.microphone_bg = theme.mode.dark_gray
theme.multimedia_bg = theme.mode.dark_yellow

theme.ethernet_bg = theme.mode.dark_gray
theme.wifi_bg = theme.mode.dark_gray
theme.bluetooth_bg = theme.mode.dark_blue
theme.future_bg = theme.mode.dark_blue

theme.rgb_keyboard_bg = theme.mode.dark_gray
theme.battery_bg = theme.mode.dark_gray
theme.battile_bg = theme.mode.dark_orange

theme.time_bg = theme.mode.dark_gray

theme.leave_bg = theme.mode.dark_red

theme.user_fg = theme.mode.fg

theme.webcam_fg = theme.mode.light_yellow
theme.volume_fg = theme.mode.light_yellow
theme.microphone_fg = theme.mode.light_yellow

theme.ethernet_fg = theme.mode.light_blue
theme.wifi_fg = theme.mode.light_blue
theme.bluetooth_fg = theme.mode.light_blue

theme.rgb_keyboard_fg = theme.mode.light_orange
theme.battery_fg = theme.mode.light_orange

theme.time_fg = theme.mode.fg

theme.leave_fg = theme.mode.light_red

theme.taglist_fg_focus = theme.mode.fg1
theme.taglist_bg_focus = theme.mode.bg1
theme.taglist_fg_urgent = theme.mode.fg3
theme.taglist_bg_urgent = theme.mode.bg3
theme.taglist_bg_occupied = theme.mode.bg2
theme.taglist_fg_occupied = theme.mode.fg
theme.taglist_shape = gears.shape.circle
theme.taglist_spacing = dpi(5)

theme.tasklist_fg_normal = theme.mode.fg
theme.tasklist_bg_normal = theme.mode.bg2
theme.tasklist_fg_focus = theme.mode.fg1
theme.tasklist_bg_focus = theme.mode.bg
theme.tasklist_fg_urgent = theme.mode.fg3
theme.tasklist_bg_urgent = theme.mode.bg3
theme.tasklist_spacing = dpi(5)

theme.eww = 1

theme.pacwall_conf = string.format([[
    hook: "hsetroot -solid '%s' -center '$W' > /dev/null"
attributes: {
    graph: "ranksep=0.72;bgcolor='%sff';dpi=92"
    package: {
        common:     "shape=point, height=0.1, fontname=monospace, fontsize=10"
        implicit:   "color='%saa'"
        explicit:   "color='%saa'"
        orphan:     "color='%saa', fontcolor='%s', peripheries=2, xlabel='\\N'"
        unneeded:   ""
        outdated:   "color='%saa', fontcolor='%s', peripheries=3, xlabel='\\N'"
        unresolved: "color='%saa', fontcolor='%s', peripheries=4, xlabel='\\N'"
        repository: {
            core: ""
            extra: ""
            community: ""
            multilib: ""
            *: "color='%s'"
        }
    }
    dependency: {
        common:   "color='%s18'"
        hard:     ""
        optional: "arrowhead=empty, style=dashed"
    }
}

]], theme.mode.bg, theme.mode.bg, theme.mode.light_yellow, theme.mode.light_blue, theme.mode.light_yellow,
    theme.mode.light_yellow, theme.mode.light_orange, theme.mode.light_orange, theme.mode.light_pink,
    theme.mode.light_pink, theme.mode.light_green, theme.mode.fg)

local file = io.open("/home/zinnia/.config/pacwall/pacwall.conf", 'w+')
if file then
    file:write(theme.pacwall_conf)
    file:close()
end
-- os.execute("pacwall -u")

awful.screen.connect_for_each_screen(function(s)
    gears.wallpaper.maximized(theme.wallpaper, s, true)
end)
return theme
