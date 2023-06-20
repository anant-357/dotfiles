local gears                 = require("gears")
local awful                 = require("awful")
local wibox                 = require("wibox")
local components            = require("components")
local functions             = require("functions")
local colors                = require("colorschemes.gruvbox")
local beautiful             = require("beautiful")
local dpi                   = require("beautiful.xresources").apply_dpi
local offsety               = dpi(100)
local screen                = awful.screen.focused()

local spr                   = wibox.widget.textbox(' ')
spr.font                    = "Fira Code, Medium 7"

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

local multimedia_all_containerized = wibar_widget_enhancor(multimedia_all, colors.dark_yellow)

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

local future_all_containerized     = wibar_widget_enhancor(future_all, colors.dark_blue)

local screenshot                   = components.screenshot({ container = "no" })

-- Battery
local battery                      = components.bat_ico({ container = "no" })

local rgb                          = components.rgb_keyboard({ container = "no" })

local leave                        = components.leave_ico({ container = "yes" })

local out                          = {}

local wibar_shape                  = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 12)
end

function out.at_screen_connect(s)
    -- If wallpaper is a function, call it with the screen
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    s.padding = {
        top = 5
    }
    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)

    s.statusbar = awful.wibox({
        -- position = "top",
        screen = s,
        bg = colors.background,
        fg = colors.foreground,
        -- border_width = 4,
        -- border_color = "#fbf1c7",
        -- shape_bounding = wibar_shape,
        -- shape_clip = functions.wi_widget_shape,
        -- shape = wibar_shape,
        type = "notification",
        y = -10,
        width = dpi(1910),
        height = dpi(45),
        visible = true,

    })

    local battile_all = wibox.widget {
        spr,
        screenshot,
        spr,
        spr,
        rgb,
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
        prompt_box_icon,
        spr,
        s.mypromptbox,
        layout = wibox.layout.fixed.horizontal

    }

    local battile_all_containerized = wibar_widget_enhancor(battile_all, colors.dark_orange)

    s.statusbar:setup {
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                spr,
                arch_icon,
                spr,
                wibar_widget_enhancor(s.mytaglist, colors.background_2),
                spr,
                wibar_widget_enhancor(prompt_box, colors.background),
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
    s.statusbar.y = 5
end

-- awful.spawn.with_shell("picom --config ~/.config/awesome/picom-jonaburg.conf -b")
-- awful.spawn.with_shell(
--     "xautolock -time 10 -notify 5 -notifier '/usr/lib/xsecurelock/until_nonidle /usr/lib/xsecurelock/dimmer' -locker xsecurelock")
-- awful.spawn.with_shell("pamixer --toggle-mute")

return out
