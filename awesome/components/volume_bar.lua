local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local format = string.format
local offsetx = dpi(320)
local offsety = dpi(100)
local screen = awful.screen.focused()
local markup = require("backend.util.markup")

local function factory(args)
    args = args or {}

    local bar_shape = args.shape or "default"

    local volume_bar_icon
    local volume_bar_adjust
    local volume_bar_bar
    local mute_icon

    volume_bar_icon = wibox.widget.textbox(markup.fg.color(beautiful.volume_fg, ""))
    mute_icon = wibox.widget.textbox(markup.fg.color(beautiful.volume_fg, "󰍯"))

    volume_bar_icon.font = "Symbols Nerd Font Mono 16"
    mute_icon.font = "Symbols Nerd Font Mono 16"

    -- create the volume_bar_adjust component
    volume_bar_adjust = wibox({
        screen = awful.screen.focused(),
        x = (screen.geometry.width / 2) - (offsetx / 2) - 420,
        y = screen.geometry.height - offsety + 35,
        height = dpi(48),
        width = offsetx,
        visible = false,
        ontop = true,
        type = "desktop",
        shape = gears.shape.rounded_bar

    })

    volume_bar_bar = wibox.widget {
        widget = wibox.widget.progressbar,
        shape = gears.shape.rounded_bar,
        color = beautiful.volume_bar_fg,
        background_color = beautiful.volume_bar_bg,
        max_value = 200,
        value = 0
    }

    volume_bar_adjust:setup{
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.align.horizontal,
            wibox.container.background(wibox.container.margin(volume_bar_bar, dpi(14), dpi(4), dpi(20), dpi(20)),
                beautiful.volume_bar_real_bg),
            forced_width = 0.7 * offsetx

        },

        wibox.container.background(wibox.container.margin(volume_bar_icon, dpi(0), dpi(0), dpi(0), dpi(0)),
            beautiful.volume_bar_real_bg),
        wibox.container.background(wibox.container.margin(mute_icon, dpi(0), dpi(22), dpi(0), dpi(0)),
            beautiful.volume_bar_real_bg)
    }

    local hide_volume_bar_adjust = gears.timer {
        timeout = 2,
        autostart = true,
        callback = function()
            volume_bar_adjust.visible = false
        end
    }

    awesome.connect_signal("volume_change", function()
        awful.spawn.easy_async_with_shell('pamixer --get-volume', function(stdout)
            local volume_bar_level = tonumber(stdout)
            volume_bar_bar.value = volume_bar_level
            if (volume_bar_level == nil) then
            elseif (volume_bar_level >= 150) then
                volume_bar_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "  󰕿"))
            elseif (volume_bar_level >= 100) then
                volume_bar_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "  󰕿"))
            elseif (volume_bar_level >= 50) then
                volume_bar_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "   󰕾"))
            elseif (volume_bar_level > 0) then
                volume_bar_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "   󰖀"))
            else
                volume_bar_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "   󰕿"))
            end
        end, false)
        awful.spawn.easy_async_with_shell('pamixer --get-mute', function(stdout)
            if (string.match(tostring(stdout), "true")) then
                volume_bar_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "   󰖁"))
            end
        end, false)
        awful.spawn.easy_async_with_shell("amixer get Capture | grep -oF '[on]' | head -n 1", function(stdout)
            if (string.match(tostring(stdout), "on")) then
                mute_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "󰍬"))
            else
                mute_icon:set_markup_silently(markup.fg.color(beautiful.volume_bar_fg, "󰍭"))
            end
        end, false)

        -- make volume_bar_adjust component visible
        if volume_bar_adjust.visible then
            hide_volume_bar_adjust:again()
        else
            volume_bar_adjust.visible = true
            hide_volume_bar_adjust:start()
        end
    end)
end

return factory
