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
local xrdb = require("beautiful.xresources").get_current_theme()

-- theme.font = "Iosevka 11"
theme.font = "Fira Code, Bold 11"
Label, ListView, NoSelection, PolicyType, ScrolledWindow,
    SignalListItemFactory, StringList, StringObject, Widget,
theme.layout_floating = gears.color.recolor_image(theme.dir .. "assets/layout/floating.png", xrdb.foreground)
theme.layout_tile = gears.color.recolor_image(theme.dir .. "assets/layout/tile.png", xrdb.foreground)

-- theme.border_width = dpi(4)
-- theme.border_focus = xrdb.color7
-- theme.border_normal = xrdb.color8
-- theme.border_focus = xrdb.color0

theme.taglist_bg_normal = xrdb.color4
theme.taglist_fg_normal = xrdb.foreground
theme.taglist_fg_focus = xrdb.foreground
theme.taglist_bg_focus = xrdb.color3
theme.taglist_fg_urgent = xrdb.foreground
theme.taglist_bg_urgent = xrdb.color6
theme.taglist_fg_occupied = xrdb.foreground
theme.taglist_bg_occupied = xrdb.color1
theme.taglist_shape = gears.shape.rounded_rect
theme.taglist_spacing = dpi(5)

theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = true
theme.tasklist_fg_normal = xrdb.foreground
theme.tasklist_bg_normal = xrdb.color1 .. "00"
theme.tasklist_fg_focus = xrdb.foreground1
theme.tasklist_bg_focus = xrdb.color1 .. "00"
theme.tasklist_fg_urgent = xrdb.foreground3
theme.tasklist_bg_urgent = xrdb.color1 .. "00 "
theme.tasklist_spacing = dpi(5)

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

theme.fg_normal = xrdb.foreground
theme.fg_focus = xrdb.color0
theme.fg_urgent = "#fb4934"
theme.useless_gap = dpi(15)

theme.bg_alt = theme.mode.bg1

-- Colors
theme.background = xrdb.background
theme.background_alt = theme.mode.bg0_h
theme.foreground = xrdb.foreground
theme.primary = theme.mode.dark_orange
theme.secondary = theme.mode.dark_yellow
theme.alert = theme.mode.dark_red
theme.disabled = theme.mode.dark_gray
theme.red = "#ee4040"

theme.notification_bg = xrdb.background
theme.notification_fg = xrdb.foreground
theme.notification_shape = gears.shape.rounded_rect

theme.tooltip_bg = xrdb.background
theme.tooltip_fg = xrdb.foreground
theme.tooltip_font = "Fira Code, Medium 10"
theme.tooltip_shape = gears.shape.rounded_rect
theme.tooltip_border_color = xrdb.background
theme.tooltip_border_width = dpi(6)

theme.user_image = theme.dir .. "assets/pfp.jpg"

theme.status_bar_bg = "#00000000"

theme.display_bar_bg = "#00000000"
-- xrdb.color1 .. "88"

theme.arch_icon_bg = xrdb.color1 .. "66"
theme.arch_icon_fg = xrdb.foreground

theme.user_bg = xrdb.color1 .. "66"

theme.mood_bg = theme.mode.bg
theme.mood_fg = xrdb.foreground
theme.mood_index = 2

theme.volume_bar_bg = xrdb.color1 .. "66"
theme.volume_bar_real_bg = xrdb.color1 .. "66"
theme.volume_bar_fg = xrdb.foreground

theme.brightness_bar_bg = xrdb.color1 .. "66"
theme.brightness_bar_real_bg = xrdb.color1 .. "66"
theme.brightness_bar_fg = xrdb.foreground

theme.spotify_bg = xrdb.color1 .. "66"
theme.spotify_fg = xrdb.foreground

theme.webcam_bg = xrdb.color1 .. "66"
theme.volume_bg = xrdb.color1 .. "66"
theme.microphone_bg = xrdb.color1 .. "66"
theme.multimedia_bg = xrdb.color1 .. "66"

theme.ethernet_bg = xrdb.color1 .. "66"
theme.wifi_bg = xrdb.color1 .. "66"
theme.bluetooth_bg = xrdb.color1 .. "66"
theme.future_bg = xrdb.color1 .. "66"

theme.rgb_keyboard_bg = xrdb.color1 .. "66"
theme.battery_bg = xrdb.color1 .. "66"
theme.battile_bg = xrdb.color1 .. "66"

theme.time_bg = xrdb.color1 .. "66"

theme.leave_bg = xrdb.color1 .. "66"

theme.user_fg = xrdb.foreground

theme.webcam_fg = xrdb.foreground
theme.volume_fg = xrdb.foreground
theme.microphone_fg = xrdb.foreground

theme.ethernet_fg = xrdb.foreground
theme.wifi_fg = xrdb.foreground
theme.bluetooth_fg = xrdb.foreground

theme.rgb_keyboard_fg = xrdb.foreground
theme.battery_fg = xrdb.foreground

theme.time_fg = xrdb.foreground

theme.leave_fg = xrdb.foreground

theme.eww_dashboard = false
theme.discharge_flag = false
theme.critical_battery_flag = false

return theme
-- theme.pacwall_conf = string.format([[
--     hook: "hsetroot -solid '%s' -center '$W' > /dev/null"
-- attributes: {
--     graph: "ranksep=0.72;bgcolor='%sff';dpi=92"
--     package: {
--         common:     "shape=point, height=0.1, fontname=monospace, fontsize=10"
--         implicit:   "color='%saa'"
--         explicit:   "color='%saa'"
--         orphan:     "color='%saa', fontcolor='%s', peripheries=2, xlabel='\\N'"
--         unneeded:   ""
--         outdated:   "color='%saa', fontcolor='%s', peripheries=3, xlabel='\\N'"
--         unresolved: "color='%saa', fontcolor='%s', peripheries=4, xlabel='\\N'"
--         repository: {
--             core: ""
--             extra: ""
--             community: ""
--             multilib: ""
--             *: "color='%s'"
--         }
--     }
--     dependency: {
--         common:   "color='%s18'"
--         hard:     ""
--         optional: "arrowhead=empty, style=dashed"
--     }
-- }

-- ]], theme.mode.bg, theme.mode.bg, theme.mode.light_yellow, theme.mode.light_blue, theme.mode.light_yellow,
--     theme.mode.light_yellow, theme.mode.light_orange, theme.mode.light_orange, theme.mode.light_pink,
--     theme.mode.light_pink, theme.mode.light_green, xrdb.foreground)

-- local file = io.open("/home/zinnia/.config/pacwall/pacwall.conf", 'w+')
-- if file then
--     file:write(theme.pacwall_conf)
--     file:close()
-- end
-- os.execute("pacwall -u")

-- awful.screen.connect_for_each_screen(function(s)
--     gears.wallpaper.maximized(theme.wallpaper, s, true)
-- end)
