local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local beautiful = require("beautiful")
local markup = require("backend.util.markup")

local cmd = "pactl list sources | sed -n -e '/Driver:/p'  -e '/Volume:/p' -e '/Mute:/p' | tail -4"

local function volicon_function(args)
    local container_bool = args.container or "no"
    local font_size = args.font_size or 12

    local volicon = wibox.widget.textbox(markup.fg.color(beautiful.microphone_fg, '󰍭'))
    local volicon_containerized = wibar_widget_enhancor(volicon, beautiful.microphone_bg)
    volicon.font = "Symbols Nerd Font Mono " .. tostring(font_size)
    local volume_status = {}

    -- ❤️👍🥲👀
    awesome.connect_signal("volume_change", function()
        awful.spawn.easy_async_with_shell(cmd, function(s)
            volume_now = {
                driver = string.match(s, "Driver: (%S+)") or "N/A",
                muted = string.match(s, "Mute: (%S+)") or "N/A"
            }

            local ch = 1
            volume_now.channel = {}
            for v in string.gmatch(s, ":.-(%d+)%%") do
                volume_now.channel[ch] = v
                ch = ch + 1
            end

            volume_now.left = volume_now.channel[1] or "N/A"
            volume_now.right = volume_now.channel[2] or "N/A"

            if volume_now.muted == "yes" then
                volicon:set_markup_silently(markup.fg.color(beautiful.microphone_fg, "󰍭"))
            else
                volicon:set_markup_silently(markup.fg.color(beautiful.microphone_fg, "󰍬"))
            end

            volume_status = volume_now
        end)
    end)

    local volume_t = awful.tooltip {
        objects = {volicon},
        timer_function = function()
            return string.format("Level: %s&#37;", volume_status.left)
        end
    }

    volicon:buttons(awful.util.table.join(awful.button({}, 1, function()
        awful.util.spawn("amixer set Capture toggle")
    end)))
    if container_bool == "yes" then
        return volicon_containerized
    else
        return volicon
    end
end

return volicon_function
