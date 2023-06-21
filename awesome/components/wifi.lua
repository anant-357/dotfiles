local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local colors                = require("colorschemes.gruvbox")

local function neticon_function(args)
    local container_bool        = args.container or "no"

    local neticon               = wibox.widget.textbox(' 󰤮')
    local neticon_containerized = wibar_widget_enhancor(neticon, colors.dark_gray)
    neticon.font                = "Symbols Nerd Font Mono 12"

    local net_status            = {}

    local net                   = backend.widget.wifi({
        timeout = 2,
        settings = function()
            -- 󰤮󰤬󰤫 󰤡󰤠 󰤤󰤣 󰤧󰤦 󰤭󰤪󰤩

            local signal = wifi_now.signal
            if signal < -83 then
                neticon:set_text(" 󰤯")
            elseif signal < -70 then
                neticon:set_text(" 󰤟")
            elseif signal < -53 then
                neticon:set_text(" 󰤢")
            elseif signal < -40 then
                neticon:set_text(" 󰤥")
            elseif signal >= -40 then
                neticon:set_text(" 󰤨")
            end
            awful.spawn.easy_async_with_shell('nmcli device wifi show-password', function(out)
                net_status.info = out
            end)
            net_status.sent = wifi_now.sent
            net_status.recieved = wifi_now.received
        end
    })

    local net_t                 = awful.tooltip {
        objects = { neticon },
        bg = colors.background,
        fg = colors.foreground,
        shape = wibar_widget_shape,
        timer_function = function()
            return backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10",
                string.format("%s\nDownload: %02.1f Mbps\nUpload: %02.1f Mbps", net_status.info,
                    net_status.recieved,
                    net_status.sent
                ))
        end
    }

    neticon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn.with_shell("zsh /home/vix/.config/rofi/wifi/wifi.sh", function() end)
        end),

        awful.button({}, 3, function()
            awful.spawn.easy_async("nmcli -fields WIFI g | grep 'enabled'", function(s)
                if s == "enabled" then
                    awful.util.spawn("nmcli radio wifi on")
                else
                    awful.util.spawn("nmcli radio wifi off")
                end
            end)
        end)
    ))
    if container_bool == "yes" then
        return neticon_containerized
    else
        return neticon
    end
end

return neticon_function
