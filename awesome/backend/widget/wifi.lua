local helpers = require("backend.helpers")
local naughty = require("naughty")
local wibox   = require("wibox")
local string  = string

-- Network infos

local function factory(args)
    args           = args or {}

    local net      = { widget = args.widget or wibox.widget.textbox(), devices = {} }
    local timeout  = args.timeout or 2
    local units    = args.units or 1024 -- KB
    local format   = args.format or "%.1f"
    local settings = args.settings or function() end


    function net.update()
        local dev         = "wlan0"
        wifi_now          = {}
        local now_t       = tonumber(helpers.first_line(string.format("/sys/class/net/%s/statistics/tx_bytes", dev)) or 0)
        local now_r       = tonumber(helpers.first_line(string.format("/sys/class/net/%s/statistics/rx_bytes", dev)) or 0)

        wifi_now.carrier  = helpers.first_line(string.format("/sys/class/net/%s/carrier", dev)) or "0"
        wifi_now.state    = helpers.first_line(string.format("/sys/class/net/%s/operstate", dev)) or "down"

        wifi_now.sent     = (now_t) / timeout / units
        wifi_now.received = (now_r) / timeout / units

        wifi_now.sent     = string.format(format, wifi_now.sent)
        wifi_now.received = string.format(format, wifi_now.received)

        if string.match(wifi_now.carrier, "1") then
            wifi_now.signal = tonumber(string.match(helpers.lines_from("/proc/net/wireless")[3], "(%-%d+%.)")) or nil
        end


        widget = net.widget
        settings()
    end

    helpers.newtimer("network", timeout, net.update)

    return net
end

return factory
