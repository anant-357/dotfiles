local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local beautiful = require("beautiful")
local markup = require("backend.util.markup")

local function neticon_function(args)
    local container_bool = args.container or "no"

    local neticon = wibox.widget.textbox(' ')
    local neticon_containerized = wibar_widget_enhancor(neticon, beautiful.wifi_bg)
    neticon.font = "Symbols Nerd Font Mono 12"

    local net_status = {}
    local net_speed = {}

    local net = backend.widget.wifi({
        timeout = 0.5,
        settings = function()
            -- 󰤮󰤬󰤫 󰤡󰤠 󰤤󰤣 󰤧󰤦 󰤭󰤪󰤩
            if wifi_now.state == "down" then
                neticon:set_markup_silently(markup.fg.color(beautiful.wifi_fg, " 󰤮"))
            else
                local signal = tonumber(wifi_now.signal) or -1000
                -- neticon:set_markup_silently(markup.fg.color(beautiful.wifi_fg,tostring(wifi_now.sent))
                if signal < -83 then
                    neticon:set_markup_silently(markup.fg.color(beautiful.wifi_fg, " 󰤯"))
                elseif signal < -70 then
                    neticon:set_markup_silently(markup.fg.color(beautiful.wifi_fg, " 󰤟"))
                elseif signal < -53 then
                    neticon:set_markup_silently(markup.fg.color(beautiful.wifi_fg, " 󰤢"))
                elseif signal < -40 then
                    neticon:set_markup_silently(markup.fg.color(beautiful.wifi_fg, " 󰤥"))
                elseif signal >= -40 then
                    neticon:set_markup_silently(markup.fg.color(beautiful.wifi_fg, " 󰤨"))
                end
            end

            net_status = wifi_now
            awful.spawn.easy_async_with_shell('nmcli -t -f active,ssid dev wifi | grep "^yes" | cut -d: -f2',
                function(out)
                    net_status.info = out
                end)
        end
    })

    local net_t = awful.tooltip {
        objects = {neticon},
    margins = 10,
    timer_function = function()
            -- local ret
            if net_status.state == "down" then
                return "Wifi Off"
            else
                return string.format("%sDownload: %02.1f Mbps\nUpload: %02.1f Mbps", net_status.info,
                    net_status.received / 80, net_status.sent / 80)
            end

            -- return ret
        end
    }

    neticon:buttons(awful.util.table.join(awful.button({}, 1, function()
        awful.spawn.with_shell("zsh /home/vix/.config/rofi/wifi/wifi.sh", function()
        end)
    end), awful.button({}, 3, function()
        awful.spawn.easy_async("nmcli -fields WIFI g | grep 'enabled'", function(s)
            if s == "enabled" then
                awful.util.spawn("nmcli radio wifi on")
            else
                awful.util.spawn("nmcli radio wifi off")
            end
        end)
    end)))
    if container_bool == "yes" then
        return neticon_containerized
    else
        return neticon
    end
end

return neticon_function
