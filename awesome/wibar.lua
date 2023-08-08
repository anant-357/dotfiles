local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local components = require("components")
local functions = require("functions")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local screen = awful.screen.focused()

local spr = wibox.widget.textbox(' ')
spr.font = "Fira Code, Medium 7"

local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape = functions.wi_widget_shape
-- Arch Icon  󰚌󰚀󰊠
local arch_icon = components.arch_ico({
    icon = "󰊠",
    containers = "single"
})

-- Clock
local time = components.time_ico({
    container = "no"
})

-- Spotify
local spotify = components.spotify_all

-- ALSA volume
local volume = components.vol_ico({
    container = "no"
})

local webcam = components.webcam({
    container = "no"
})

local microphone = components.microphone({
    container = "no"
})

local multimedia_all = wibox.widget {
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

local multimedia_all_containerized = wibar_widget_enhancor(multimedia_all, beautiful.multimedia_bg)

-- Net
local ethernet = components.ethernet({
    container = "no"
})

-- Net
local wifi = components.wifi_ico({
    container = "no"
})

-- Bluetooth 󰂯󰂰󰂱󰂲󰂳󰂴󰍬󰍭 󰤾󰤿󰥀󰥁󰥂󰥃󰥄󰥅󰥆󰥇󰥈󰥉󰥊
local bluetooth = components.blue_ico({
    container = "no"
})

local future_all = wibox.widget {
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

local future_all_containerized = wibar_widget_enhancor(future_all, beautiful.future_bg)

-- Battery
local battery = components.bat_ico({
    container = "no"
})

local rgb = components.rgb_keyboard({
    container = "no"
})

local leave = components.leave_ico({
    container = "yes"
})

local s = awful.screen.focused()

local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal("request::activate", "tasklist", {
            raise = true
        })
    end
end), awful.button({}, 3, function()
    awful.menu.client_list({
        theme = {
            width = 250
        }
    })
end), awful.button({}, 4, function()
    awful.client.focus.byidx(1)
end), awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
end))

awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    max_widget_size = dpi(100),
    layout = {
        spacing = 1,
        spacing_widget = {
            {
                forced_width = 4,
                widget = wibox.widget.separator
            },
            valign = 'center',
            halign = 'center',
            widget = wibox.container.place
        },
        layout = wibox.layout.flex.horizontal
    }

}
local wibar_tasklist_enhancor = function(widget)
    return wibox.container.margin(widget, 0, 0, 5, 5)
end

local add_tag = components.add_tag

s.mypromptbox = awful.widget.prompt()

s.mylayoutbox = awful.widget.layoutbox(s)

s.statusbar = awful.wibox({
    screen = s,
    bg = beautiful.status_bar_bg,
    fg = beautiful.foreground,

    width = dpi(1900),
    height = dpi(60),
    visible = true,
    type = "notification"

})

s.displaybar = awful.wibox({
    screen = s,
    bg = beautiful.display_bar_bg,
    fg = beautiful.foreground,
    type = "notification",
    width = dpi(1900),
    height = dpi(35),
    visible = true

})

local battile_all = wibox.widget {

    spr,
    rgb,
    spr,
    spr,
    battery,
    spr,
    spr,
    wibar_tasklist_enhancor(s.mylayoutbox, beautiful.mode.battery_fg),
    spr,
    layout = wibox.layout.fixed.horizontal
}

local user = components.user()

local prompt_box_icon = components.mood_ico({
    -- container = "no"
})

local prompt_box = wibox.widget {
    prompt_box_icon,
    spr,
    s.mypromptbox,
    layout = wibox.layout.fixed.horizontal

}

local battile_all_containerized = wibar_widget_enhancor(battile_all, beautiful.battile_bg)

s.statusbar:setup{
    layout = wibox.layout.stack,
    {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            spr,
            arch_icon,
            user
        },
        nil,
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

s.displaybar:setup{
    layout = wibox.layout.stack,
    {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            -- spr,
            -- wibar_tasklist_enhancor(
            s.mytaglist -- , beautiful.background)
            ,
            spr,
            add_tag,
            spr,
            spr,
            prompt_box,
            spr

        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            wibar_tasklist_enhancor(s.mytasklist, beautiful.background)
        }
    },
    {
        time,
        layout = wibox.container.place,
        halign = "center"
    }
}
s.statusbar.y = screen.geometry.height - 70
s.displaybar.y = 10
