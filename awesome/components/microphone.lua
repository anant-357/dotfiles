local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local beautiful                = require("beautiful")

local function volicon_function(args)
    local container_bool        = args.container or "no"
    local font_size             = args.font_size or 12

    local volicon               = wibox.widget.textbox('󰍭')
    local volicon_containerized = wibar_widget_enhancor(volicon, beautiful.microphone_bg)
    volicon.font                = "Symbols Nerd Font Mono " .. tostring(font_size)
    local volume_status         = {}
    local volume                = backend.widget.microphone({
        timeout = 0.1,
        settings = function()
            if volume_now.muted == "yes" then
                volicon:set_text("󰍭")
            else
                volicon:set_text("󰍬")
            end

            volume_status = volume_now
        end
    })

    local volume_t              = awful.tooltip {
        objects = { volicon },
        shape = wibar_widget_shape,
        timer_function = function()
            return backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10",
                string.format("Level: %s&#37;\n", volume_status.left))
        end
    }

    volicon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.util.spawn("amixer set Capture toggle")
        end)
    ))
    if container_bool == "yes" then
        return volicon_containerized
    else
        return volicon
    end
end

return volicon_function
