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

    if container_bool == "no" then
        time_containerized = time
    end

    time_containerized:buttons(awful.util.table.join(awful.button({}, 1, function()
        awful.spawn.easy_async("sh /home/zinnia/.config/eww/dashboard/launch_dashboard", function()
        end)
    end)))

    local time_t = awful.tooltip {
        objects = {time_containerized},
        timer_function = function()
            return string.format(os.date('%B %d %Y, %A\n%T'))
        end
    }

    return time_containerized

end

return timeicon_function
