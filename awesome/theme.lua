local dpi                                       = require("beautiful.xresources").apply_dpi
local os                                        = os
local gears                                     = require("gears")
local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/"
theme.wallpaper                                 = theme.dir .. "/wallpapers/gruvbox/deer.jpg"
theme.colors                                    = require("colorschemes.everforest.main")
theme.mode                                      = theme.colors.dark
theme.font                                      = "Fira Code, Medium 11"
theme.fg_normal                                 = theme.mode.fg0
theme.fg_focus                                  = theme.mode.fg1
theme.fg_urgent                                 = "#fb4934"
theme.bg_normal                                 = theme.mode.bg
theme.bg_focus                                  = "#1d2021"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_width                              = dpi(3)
theme.border_normal                             = theme.mode.dark_gray
theme.border_focus                              = theme.mode.dark_gray
theme.useless_gap                               = dpi(15)
theme.layout_tile                               = "󰢡"
theme.tasklist_disable_icon                     = true

theme.bg_alt                                    = theme.mode.bg1

-- Colors
theme.background                                = theme.mode.bg
theme.background_alt                            = theme.mode.bg0_h
theme.foreground                                = theme.mode.fg0
theme.primary                                   = theme.mode.dark_orange
theme.secondary                                 = theme.mode.dark_yellow
theme.alert                                     = theme.mode.dark_red
theme.disabled                                  = theme.mode.dark_gray

theme.notification_bg                           = theme.mode.bg
theme.notification_fg                           = theme.mode.fg
theme.tooltip_bg                                = theme.mode.bg
theme.tooltip_fg                                = theme.mode.fg
theme.border_normal                             = theme.mode.dark_gray
theme.border_focus                              = theme.mode.dark_gray
theme.border_marked                             = "#CC9393"

theme.user_image                                = theme.dir .. "assets/pfp.jpg"

theme.titlebar_close_button_normal              = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.bg_alt)
theme.titlebar_close_button_focus               = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_2.png",
    theme.mode.dark_red)

theme.titlebar_minimize_button_normal           = gears.color.recolor_image(
    theme.dir .. "assets/titlebar/minimize_1.png", theme.bg_alt)
theme.titlebar_minimize_button_focus            = gears.color.recolor_image(
    theme.dir .. "assets/titlebar/minimize_2.png", theme.mode.dark_green)

theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.bg_alt)
theme.titlebar_maximized_button_focus_inactive  = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.mode.dark_yellow)
theme.titlebar_maximized_button_normal_active   = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.bg_alt)
theme.titlebar_maximized_button_focus_active    = gears.color.recolor_image(theme.dir .. "assets/titlebar/close_1.png",
    theme.mode.dark_yellow)

theme.arch_icon_bg                              = theme.mode.bg0_h
theme.user_bg                                   = theme.mode.bg

theme.volume_bar_bg                             = theme.mode.background

theme.brightness_bar_bg                         = theme.background

theme.spotify_bg                                = theme.mode.dark_green

theme.webcam_bg                                 = theme.mode.dark_gray
theme.volume_bg                                 = theme.mode.dark_gray
theme.microphone_bg                             = theme.mode.dark_gray
theme.multimedia_bg                             = theme.mode.dark_yellow

theme.ethernet_bg                               = theme.mode.dark_gray
theme.wifi_bg                                   = theme.mode.dark_gray
theme.bluetooth_bg                              = theme.mode.dark_blue
theme.future_bg                                 = theme.mode.dark_blue

theme.rgb_keyboard_bg                           = theme.mode.dark_gray
theme.battery_bg                                = theme.mode.dark_gray
theme.battile_bg                                = theme.mode.dark_orange

theme.time_bg                                   = theme.mode.dark_gray

theme.leave_bg                                  = theme.mode.dark_red

theme.taglist_fg_focus                          = theme.mode.fg1
theme.taglist_bg_focus                          = theme.mode.bg1
theme.taglist_fg_urgent                         = theme.mode.fg3
theme.taglist_bg_urgent                         = theme.mode.bg3
theme.taglist_bg_occupied                       = theme.mode.bg2
theme.taglist_fg_occupied                       = theme.mode.fg

theme.tasklist_fg_focus                         = theme.mode.fg1
theme.tasklist_bg_focus                         = theme.mode.bg1
theme.tasklist_fg_urgent                        = theme.mode.fg3
theme.tasklist_bg_urgent                        = theme.mode.bg3
theme.tasklist_bg_occupied                      = theme.mode.bg2
theme.tasklist_fg_occupied                      = theme.mode.fg

theme.pacwall_conf                              = string.format([[
    hook: "hsetroot -solid '%s' -center '$W' > /dev/null"
attributes: {
    graph: "ranksep=0.72;bgcolor='%sff';dpi=92"
    package: {
        common:     "shape=point, height=0.1, fontname=monospace, fontsize=10"
        implicit:   "color='#af3a03aa'"
        explicit:   "color='#076678aa'"
        orphan:     "color='#427b58aa', fontcolor='#427b58', peripheries=2, xlabel='\\N'"
        unneeded:   ""
        outdated:   "color='#b57614aa', fontcolor='#b57614', peripheries=3, xlabel='\\N'"
        unresolved: "color='#b16286aa', fontcolor='#b16286', peripheries=4, xlabel='\\N'"
        repository: {
            core: ""
            extra: ""
            community: ""
            multilib: ""
            *: "color='#79740eaa'"
        }
    }
    dependency: {
        common:   "color='%s0f'"
        hard:     ""
        optional: "arrowhead=empty, style=dashed"
    }
}

]], theme.mode.bg, theme.mode.bg, theme.mode.fg)

local file                                      = io.open("/home/vix/.config/pacwall/pacwall.conf", 'w+')
if file then
    file:write(theme.pacwall_conf)
    file:close()
end
os.execute("pacwall -u")


return theme
