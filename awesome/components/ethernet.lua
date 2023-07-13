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
    local font_size = args.font_size or 10

    local neticon = wibox.widget.textbox(markup.fg.color(beautiful.ethernet_fg, '󰈀'))
    local neticon_containerized = wibar_widget_enhancor(neticon, beautiful.ethernet_bg)
    neticon.font = "Symbols Nerd Font Mono " .. tostring(font_size)

    local net_status = {}

    local net = backend.widget.ethernet({
        timeout = 2,
        settings = function()
            -- 󰤮󰤬󰤫 󰤡󰤠 󰤤󰤣 󰤧󰤦 󰤭󰤪󰤩

            if ethernet_now.carrier == "0" then
                neticon:set_markup_silently(markup.fg.color(beautiful.ethernet_fg, "󰈀"))
                neticon.font = "Symbols Nerd Font Mono 12"
            else
                neticon:set_markup_silently(markup.fg.color(beautiful.ethernet_fg, ""))
                neticon.font = "Symbols Nerd Font Mono 12"
            end
            net_status.carrier = ethernet_now.carrier
            net_status.sent = ethernet_now.sent
            net_status.recieved = ethernet_now.received
        end
    })

    local net_t = awful.tooltip {
        objects = {neticon},
        shape = wibar_widget_shape,
        timer_function = function()
            if net_status.carrier == "0" then
                return backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10", "Not Connected")
            end
            return backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10", string.format(
                "Download: %02.1f Mbps\nUpload: %02.1f Mbps", net_status.recieved / 1024, net_status.sent / 1024))
        end
    }
    if container_bool == "yes" then
        return neticon_containerized
    else
        return neticon
    end
end

return neticon_function
