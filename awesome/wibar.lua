local awful                 = require("awful")
local wibox                 = require("wibox")
local components            = require("components")
local functions             = require("functions")
local colors                = require("colorschemes.gruvbox")
local dpi                   = require("beautiful.xresources").apply_dpi
local screen                = awful.screen.focused()

local spr                   = wibox.widget.textbox(' ')
spr.font                    = "Fira Code, Medium 7"

local wibar_widget_enhancor = functions.wi_widget_enhancor

-- Arch Icon  󰚌󰚀󰊠
local arch_icon             = components.arch_ico({ icon = "󰊠", containers = "single" })

-- Clock
local time                  = components.time_ico({ container = "no" })

-- Spotify
local spotify               = components.spotify_all

-- ALSA volume
local volume                = components.vol_ico({ container = "no" })

local webcam                = components.webcam({ container = "no" })

local microphone            = components.microphone({ container = "no" })


local multimedia_all               = wibox.widget {
    spr,
    webcam,
    spr,
    spr,
    volume,
    spr,
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
    spr,
    wifi,
    spr,
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

local s                            = awful.screen.focused()

awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

s.padding = {
    top = -60,
    bottom = 64,
    left = 10,
    right = 10
}
s.mypromptbox = awful.widget.prompt()

s.mylayoutbox = awful.widget.layoutbox(s)

s.statusbar = awful.wibox({
    screen = s,
    bg = colors.background,
    fg = colors.foreground,
    type = "notification",
    width = dpi(1900),
    height = dpi(60),
    visible = true,

})

s.displaybar = awful.wibox({
    screen = s,
    bg = colors.background,
    fg = colors.foreground,
    type = "notification",
    width = dpi(1900),
    height = dpi(35),
    visible = true,

})

local battile_all = wibox.widget {
    spr,
    screenshot,
    spr,
    spr,
    spr,
    rgb,
    spr,
    spr,
    battery,
    spr,
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
            leave,
            -- spr,
            arch_icon,
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            spr,
            spotify,
            -- spr,
            multimedia_all_containerized,
            -- spr,
            future_all_containerized,
            -- spr,
            battile_all_containerized,
            spr,

        }

    }
}

s.displaybar:setup {
    layout = wibox.layout.stack,
    {
        layout = wibox.layout.fixed.horizontal,
        -- wibar_widget_enhancor(
        s.mytaglist,
        -- colors.background_2),
        spr,
        -- wibar_widget_enhancor(
        prompt_box,
        --  colors.background),
    },

    {
        time,
        valign = "center",
        halign = "center",
        layout = wibox.container.place
    }

}
s.statusbar.y = screen.geometry.height - 70
s.displaybar.y = 10
