local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local beautiful = require("beautiful")
local markup = require("backend.util.markup")

local function rgb_keyboard_icon(args)
    local container_bool = args.container or "no"
    local font_size = args.font_size or 14

    local rgb_keyboard_icon = wibox.widget.textbox(markup.fg.color(beautiful.rgb_keyboard_fg, ' '))

    rgb_keyboard_icon.font = "Symbols Nerd Font Mono " .. tostring(font_size)

    local rgb_keyboard_icon_containerized = wibar_widget_enhancor(rgb_keyboard_icon, beautiful.rgb_keyboard_bg)

    rgb_keyboard_icon:buttons(awful.util.table.join(awful.button({}, 1, function()
        awful.spawn.easy_async("rgb_config_acer_gkbbl_0", function()
        end)
    end)))
    local rgb_keyboard_icon_t = awful.tooltip {
        objects = {rgb_keyboard_icon},
    margins = 10,
    timer_function = function()
            return "RGB keyboard settings"
        end
    }

    if container_bool == "yes" then
        return rgb_keyboard_icon_containerized
    else
        return rgb_keyboard_icon
    end
end

return rgb_keyboard_icon
