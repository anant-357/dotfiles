local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local beautiful = require("beautiful")

local function timeicon_function(args)
    local container_bool = args.container or "no"
    local time = wibox.widget.textclock(string.format('<span color="%s" ', beautiful.time_fg) ..
                                            'font="Fira Code, Medium 10"> %H:%M </span>', 5)

    local time_containerized = wibar_widget_enhancor(time, beautiful.time_bg)

    local time_t = awful.tooltip {
        objects = {time_containerized},
        shape = wibar_widget_shape,
        timer_function = function()
            return backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10", string.format("Time"))
        end
    }
    if container_bool == "yes" then
        return time_containerized
    else
        return time
    end
end

return timeicon_function
