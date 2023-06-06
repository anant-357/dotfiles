local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend                  = require("backend")
local colors                = require("colorschemes.gruvbox")

local function neticon_function(args)
    local container_bool        = args.container or "no"
    
    local neticon               = wibox.widget.textbox(' 󰤮 ')
    local neticon_containerized = wibar_widget_enhancor(neticon, colors.dark_gray)
    neticon.font                = "Symbols Nerd Font Mono 12"

    local net_status            = {}

    local net                   = backend.widget.net({
        timeout = 2,
        notify = "off",
        wifi_state = "on",
        eth_state = "on",
        settings = function()
            local eth0 = net_now.devices.eth0
            if eth0 then
                if eth0.ethernet then
                    neticon:set_image("10+")
                else
                    neticon:set_text("10")
                end
            end

            local wlan0 = net_now.devices.wlan0
            -- 󰤮󰤬󰤫 󰤡󰤠 󰤤󰤣 󰤧󰤦 󰤭󰤪󰤩

            if wlan0 then
                if wlan0.wifi then
                    local signal = wlan0.signal
                    if signal < -83 then
                        neticon:set_text("󰤯")
                    elseif signal < -70 then
                        neticon:set_text("󰤟")
                    elseif signal < -53 then
                        neticon:set_text("󰤢")
                    elseif signal < -40 then
                        neticon:set_text("󰤥")
                    elseif signal >= -40 then
                        neticon:set_text("󰤨")
                    end
                else
                    neticon:set_text("?")
                end
                awful.spawn.easy_async_with_shell('nmcli device wifi show-password', function(out)
                    net_status.info = out
                end)
            end
            net_status.sent = net_now.sent
            net_status.recieved = net_now.received
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
                    net_status.recieved / 1024,
                    net_status.sent / 1024
                ))
        end
    }
    if container_bool == "yes" then
        return neticon_containerized
    else
        return neticon
    end
end

return neticon_function
