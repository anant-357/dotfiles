local helpers = require("backend.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local awful   = require("awful")

local function factory(args)
    args            = args or {}

    local bluetooth = { widget = args.widget or wibox.widget.textbox() }
    local timeout   = args.timeout or 1
    local settings  = args.settings or function() end

    local base      = "bluetoothctl show | sed -n -e '/PowerState:/p' -e '/Discoverable:/p' -e '/Pairable:/p'"
    local connected = "bluetoothctl info | sed -n -e '/Name:/p' -e '/Icon:/p' -e '/Battery Percentage:/p'"

    bluetooth_icons = {
        ["audio-card"]        = "󰚗",
        ["audio-headphones"]  = "󰋋", --
        ["audio-headset"]     = "󰋎",
        ["camera-photo"]      = "",
        ["camera-video"]      = "",
        ["computer"]          = "",
        ["input-gaming"]      = "󰊴", --󰊗
        ["input-keyboard"]    = "",
        ["input-mouse"]       = "󰍽",
        ["input-tablet"]      = "",
        ["modem"]             = "",
        ["multimedia-player"] = "",
        ["network-wireless"]  = "",
        ["network-wired"]     = "",
        ["phone"]             = "",
        ["printer"]           = "󰐪",
        ["scanner"]           = "󰚫",
        ["unknown"]           = "󰂳",
        ["video-display"]     = ""
    }
    --󰈈󰈉󰛐󰛑  

    function bluetooth.update()
        helpers.async({ shell, "-c", base },
            function(s)
                bluetooth_now              = {}
                bluetooth_now.status       = string.match(s, "PowerState: (%S+)") or "N/A"
                bluetooth_now.discoverable = string.match(s, "Discoverable: (%S+)") or "N/A"
                bluetooth_now.pairable     = string.match(s, "Pairable: (%S+)") or "N/A"
                awful.spawn.easy_async_with_shell(connected, function(s)
                    bluetooth_now.connected = {}
                    if string.match(s, "Icon") then
                        bluetooth_now.is_connected = "yes"
                        bluetooth_now.connected.name = string.match(s, "Name: ([^\n]+)") or "N/A"
                        bluetooth_now.connected.icon = string.match(s, "Icon: (%S+)") or "N/A"
                        bluetooth_now.connected.battery = string.match(s, "Battery Percentage: (%S+)") or "N/A"
                    else
                        bluetooth_now.is_connected = "no"
                    end
                end)
            end)

        settings()
    end

    bluetooth.timer = helpers.newtimer("bluetooth", timeout, bluetooth.update, true, true)

    return bluetooth
end

return factory
