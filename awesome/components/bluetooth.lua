local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local beautiful = require("beautiful")
local markup = require("backend.util.markup")

local function bluetooth_icon_function(args)
    local container_bool = args.container or "no"
    local bluetooth_icon = wibox.widget.textbox(markup.fg.color(beautiful.bluetooth_fg, '󰂱'))
    local font_size = args.font_size or 12
    bluetooth_icon.font = "Symbols Nerd Font Mono " .. tostring(font_size)

    local bluetooth_status = {}

    local bluetooth_icon_containerized = wibar_widget_enhancor(bluetooth_icon, beautiful.bluetooth_bg)

    local bluetooth = backend.widget.bluetooth({
        timeout = 1,
        settings = function()
            if bluetooth_now.status == "on" then
                bluetooth_icon:set_markup_silently(markup.fg.color(beautiful.bluetooth_fg, "󰂯"))
                if bluetooth_now.is_connected == "yes" then
                    bluetooth_icon:set_markup_silently(markup.fg.color(beautiful.bluetooth_fg,
                        bluetooth_icons[bluetooth_now.connected.icon]))
                    bluetooth_icon.font = "Symbols Nerd Font Mono 11"
                end
            else
                bluetooth_icon:set_markup_silently(markup.fg.color(beautiful.bluetooth_fg, "󰂲"))
            end
            bluetooth_status = bluetooth_now
        end
    })

    bluetooth_icon:buttons(awful.util.table.join(awful.button({}, 1, function()
        if bluetooth_status.status == "on" then
            awful.util.spawn("bluetoothctl power off")
        else
            awful.util.spawn("bluetoothctl power on")
        end
    end)))

    local bluetooth_t = awful.tooltip {
        objects = {bluetooth_icon},
    margins = 10,
    timer_function = function()
            if bluetooth_status.status == "off" then
                return "Bluetooth Off"
            end

            if bluetooth_status.is_connected == "no" then
                return "Not connected"
            end

            local ret = string.format("Name: %s\n", bluetooth_status.connected.name)
            if bluetooth_status.connected.battery == "N/A" or nil then
            else
                ret = ret .. string.format("Battery: %s&#37;", tostring(tonumber(bluetooth_status.connected.battery)))
            end

            return ret
        end
    }

    if container_bool == "yes" then
        return bluetooth_icon_containerized
    else
        return bluetooth_icon
    end
end

return bluetooth_icon_function
