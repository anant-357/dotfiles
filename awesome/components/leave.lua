-- logout -- 󰑮󰭔󰯧⏻
local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local beautiful = require("beautiful")
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local markup = require("backend.util.markup")

local function leaveicon_function(args)
    local container_bool = args.container or "no"
    local font_size = args.font_size or 14
    local leave_icon = wibox.widget.textbox(markup.fg.color(beautiful.leave_fg, '󰐦'))
    local leave_icon_containerized = wibar_widget_enhancor(leave_icon, beautiful.leave_bg)
    leave_icon.font = "Symbols Nerd Font Mono " .. tostring(font_size)

    leave_icon_containerized:buttons(awful.util.table.join(awful.button({}, 1, function()
        awful.spawn.easy_async("sh /home/zinnia/.config/rofi/powermenu/powermenu.sh", function()
        end)
    end)))

    local leave_t = awful.tooltip {
        objects = {leave_icon},
    margins = 10,
    timer_function = function()
            return "Exit Menu"
        end
    }

    if container_bool == "yes" then
        return leave_icon_containerized
    else
        return leave_icon
    end
end

return leaveicon_function
