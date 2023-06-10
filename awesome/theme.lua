local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local dpi           = require("beautiful.xresources").apply_dpi
local components    = require("components")

local functions     = require("functions")
local os            = os

local theme         = {}
theme.dir           = os.getenv("HOME") .. "/.config/awesome/"
theme.wallpaper     = theme.dir .. "/wallpapers/gruvbox/deer.jpg"
theme.colors        = require('colorschemes.gruvbox')

theme.font          = "Fira Code, Medium 11"
theme.fg_normal     = "#ebdbb2"
theme.fg_focus      = "#fabd2f"
theme.fg_urgent     = "#fb4934"
theme.bg_normal     = "#282828"
theme.bg_focus      = "#1d2021"
theme.bg_urgent     = "#1A1A1A"
theme.border_width  = dpi(3)
theme.border_normal = theme.colors.dark_gray
theme.border_focus  = theme.colors.light_gray
theme.border_marked = "#CC9393"
theme.useless_gap   = dpi(7)
theme.layout_tile   = "󰢡"

-- Colors


theme.background     = "#282828"
theme.background_alt = "#1d2021"
theme.foreground     = "#ebdbb2"
theme.primary        = theme.colors.light_orange
theme.secondary      = theme.colors.light_yellow
theme.alert          = theme.colors.light_red
theme.disabled       = theme.colors.light_gray


theme.notification_bg = "#282828"
theme.notification_fg = "#ebdbb2"
theme.tooltip_bg      = "#282828"
theme.tooltip_fg      = "#ebdbb2"
theme.border_normal   = "#3F3F3F"
theme.border_focus    = "#7F7F7F"
theme.border_marked   = "#CC9393"


local spr = wibox.widget.textbox('  ')

local wibar_widget_enhancor = functions.wi_widget_enhancor


-- Arch Icon  󰚌󰚀󰊠
local arch_icon  = components.arch_ico({ icon = "󰊠", containers = "single" })

-- Clock
local time       = components.time_ico({ container = "yes" })

-- Spotify
local spotify    = components.spotify_all

-- ALSA volume
local volume     = components.vol_ico({ container = "no" })

local webcam     = components.webcam({ container = "no" })

local microphone = components.microphone({ container = "no" })


local multimedia_all               = wibox.widget {
    spr,
    webcam,
    spr,
    volume,
    spr,
    microphone,
    spr,
    layout = wibox.layout.fixed.horizontal
}

local multimedia_all_containerized = wibar_widget_enhancor(multimedia_all, theme.colors.dark_yellow)

-- Net
local ethernet                     = components.ethernet({ container = "no" })

-- Net
local wifi                         = components.wifi_ico({ container = "no" })

-- Bluetooth 󰂯󰂰󰂱󰂲󰂳󰂴󰍬󰍭 󰤾󰤿󰥀󰥁󰥂󰥃󰥄󰥅󰥆󰥇󰥈󰥉󰥊
local bluetooth                    = components.blue_ico({ container = "no" })

local future_all                   = wibox.widget {
    spr,
    ethernet,
    spr,
    wifi,
    spr,
    bluetooth,
    spr,
    layout = wibox.layout.fixed.horizontal
}

local future_all_containerized     = wibar_widget_enhancor(future_all, theme.colors.dark_blue)

local screenshot                   = components.screenshot({ container = "no" })

-- Battery
local battery                      = components.bat_ico({ container = "no" })

local leave                        = components.leave_ico({ container = "yes" })


function theme.at_screen_connect(s)
    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)

    s.statusbar = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(34),
        bg = theme.bg_normal,
        fg = theme.fg_normal,
        border_width = 4,
        border_color = theme.colors.light_gray
    })

    local battile_all = wibox.widget {
        spr,
        screenshot,
        spr,
        spr,
        battery,
        spr,
        s.mylayoutbox,
        spr,
        layout = wibox.layout.fixed.horizontal
    }

    local prompt_box_icon = wibox.widget.textbox("󰗣")
    prompt_box_icon.font = "Symbols Nerd Font Mono 11"

    local prompt_box = wibox.widget {
        spr,
        prompt_box_icon,
        spr,
        s.mypromptbox,
        layout = wibox.layout.fixed.horizontal

    }

    local battile_all_containerized = wibar_widget_enhancor(battile_all, theme.colors.dark_orange)

    s.statusbar:setup {
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                spr,
                arch_icon,
                spr,
                wibar_widget_enhancor(s.mytaglist, theme.colors.background_2),
                spr,
                wibar_widget_enhancor(prompt_box, theme.colors.background),
                spr,
            },
            {
                time,
                valign = "center",
                halign = "center",
                layout = wibox.container.place
            },
            {
                layout = wibox.layout.fixed.horizontal,
                spr,
                spotify,
                spr,
                multimedia_all_containerized,
                spr,
                future_all_containerized,
                spr,
                battile_all_containerized,
                spr,
                leave,
                spr
            }

        }
    }
end

-- awful.spawn.with_shell("picom --config ~/.config/awesome/picom-jonaburg.conf -b")
-- awful.spawn.with_shell(
--     "xautolock -time 10 -notify 5 -notifier '/usr/lib/xsecurelock/until_nonidle /usr/lib/xsecurelock/dimmer' -locker xsecurelock")
-- awful.spawn.with_shell("pamixer --toggle-mute")
awful.spawn.with_shell("pamixer --toggle-mute")



return theme
