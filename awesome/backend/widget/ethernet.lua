local helpers = require("backend.helpers")
local naughty = require("naughty")
local wibox   = require("wibox")
local string  = string

-- Network infos

local function factory(args)
    args           = args or {}

    local ethernet = { widget = args.widget or wibox.widget.textbox(), devices = {} }
    local timeout  = args.timeout or 2
    local units    = args.units or 1024 -- KB
    local format   = args.format or "%.1f"
    local settings = args.settings or function() end


    function ethernet.update()
        local dev             = "enp0s20f0u5"
        ethernet_now          = {}
        local now_t           = tonumber(helpers.first_line(string.format("/sys/class/net/%s/statistics/tx_bytes",
            dev)) or 0)
        local now_r           = tonumber(helpers.first_line(string.format("/sys/class/net/%s/statistics/rx_bytes",
            dev)) or 0)

        ethernet_now.carrier  = helpers.first_line(string.format("/sys/class/net/%s/carrier", dev)) or "0"
        ethernet_now.state    = helpers.first_line(string.format("/sys/class/net/%s/operstate", dev)) or "down"

        ethernet_now.sent     = (now_t) / timeout / units
        ethernet_now.received = (now_r) / timeout / units

        ethernet_now.sent     = string.format(format, ethernet_now.sent)
        ethernet_now.received = string.format(format, ethernet_now.received)

        settings()
    end

    helpers.newtimer("ethernet", timeout, ethernet.update)

    return ethernet
end

return factory
