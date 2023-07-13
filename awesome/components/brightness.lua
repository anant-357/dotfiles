local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local format = string.format
local offsetx = dpi(300)
local offsety = dpi(100)
local screen = awful.screen.focused()
local markup = require("backend.util.markup")

local brightness_icon = wibox.widget.textbox("")
brightness_icon.font = "Symbols Nerd Font Mono 18"

-- create the brightness_adjust component
local brightness_adjust = wibox({
    screen = awful.screen.focused(),
    x = (screen.geometry.width / 2) - (offsetx / 2) + 150,
    y = screen.geometry.height - offsety + 35,
    height = dpi(48),
    width = offsetx,
    visible = false,
    ontop = true,
    type = "desktop"
})

local brightness_bar = wibox.widget {
    widget = wibox.widget.progressbar,
    -- shape = gears.shape.rounded_bar,
    color = beautiful.brightness_bar_fg,
    background_color = beautiful.brightness_bar_bg,
    max_value = 100,
    value = 0
}

brightness_adjust:setup{
    layout = wibox.layout.align.horizontal,
    {
        layout = wibox.layout.align.horizontal,
        wibox.container.background(wibox.container.margin(brightness_bar, dpi(14), dpi(4), dpi(20), dpi(20)),
            beautiful.brightness_bar_bg),
        forced_width = 0.8 * offsetx

    },

    wibox.container.background(wibox.container.margin(brightness_icon, dpi(0), dpi(0), dpi(0), dpi(0)),
        beautiful.brightness_bar_bg)
}

-- create a 2 second timer to hide the brightness adjust
-- component whenever the timer is started
local hide_brightness_adjust = gears.timer {
    timeout = 2,
    autostart = true,
    callback = function()
        brightness_adjust.visible = false
    end
}

-- show brightness-adjust when "brightness_change" signal is emitted
awesome.connect_signal("brightness_change", function()
    awful.spawn.easy_async_with_shell('xbacklight -get', function(stdout)
        local brightness_level = tonumber(stdout)
        brightness_bar.value = brightness_level
        if (brightness_level == nil) then
        elseif (brightness_level == 100) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 90) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 80) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 70) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 60) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 50) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 40) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 30) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 25) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 20) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 15) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 10) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 5) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        elseif (brightness_level > 0) then
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        else
            brightness_icon:set_markup_silently(format("<span foreground='%s'>   </span>", beautiful.foreground))
        end
    end, false)

    -- make brightness_adjust component visible
    if brightness_adjust.visible then
        hide_brightness_adjust:again()
    else
        brightness_adjust.visible = true
        hide_brightness_adjust:start()
    end
end)
