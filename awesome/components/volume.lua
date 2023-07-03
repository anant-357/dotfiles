local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local beautiful             = require("beautiful")

local cmd                   =
"pactl list sinks | sed -n -e '/Driver:/p' -e '/Base Volume:/d' -e '/Volume:/p' -e '/Mute:/p' -e '/device\\.string/p'"


local function volicon_function(args)
    local container_bool        = args.container or "no"

    local volicon               = wibox.widget.textbox(' 󰖁 ')
    local volicon_containerized = wibar_widget_enhancor(volicon, beautiful.volume_bg)
    volicon.font                = "Symbols Nerd Font Mono 11"
    local volume_status         = {}


    awesome.connect_signal("volume_change", function()
        awful.spawn.easy_async_with_shell(cmd,
            function(s)
                volume_now = {
                    driver = string.match(s, "Driver: (%S+)") or "N/A",
                    muted  = string.match(s, "Mute: (%S+)") or "N/A"
                }

                local ch = 1
                volume_now.channel = {}
                for v in string.gmatch(s, ":.-(%d+)%%") do
                    volume_now.channel[ch] = v
                    ch = ch + 1
                end

                volume_now.left  = volume_now.channel[1] or "N/A"
                volume_now.right = volume_now.channel[2] or "N/A"

                if volume_now.muted == "yes" then
                    volicon:set_text(" 󰖁 ")
                elseif tonumber(volume_now.left) + tonumber(volume_now.right) == 0 then
                    volicon:set_text(" 󰕿 ")
                elseif tonumber(volume_now.left) + tonumber(volume_now.right) <= 100 then
                    volicon:set_text(" 󰖀 ")
                elseif tonumber(volume_now.left) + tonumber(volume_now.right) <= 200 then
                    volicon:set_text(" 󰕾 ")
                elseif tonumber(volume_now.left) + tonumber(volume_now.right) <= 300 then
                    volicon:set_text("󰕿")
                else
                    volicon:set_text("󰕿")
                end

                volume_status = volume_now
            end
        )
    end)

    local volume_t = awful.tooltip {
        objects = { volicon },
        shape = wibar_widget_shape,
        timer_function = function()
            return backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10",
                string.format("Volume: %s&#37;\n", volume_status.left))
        end
    }

    volicon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn.easy_async("pamixer --toggle-mute", function()

            end)
            awesome.emit_signal("volume_change")
        end)
    ))
    if container_bool == "yes" then
        return volicon_containerized
    else
        return volicon
    end
end

return volicon_function
