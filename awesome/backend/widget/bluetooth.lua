local helpers = require("backend.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")

local function factory(args)
    args            = args or {}

    local bluetooth = { widget = args.widget or wibox.widget.textbox() }
    local timeout   = args.timeout or 1
    local settings  = args.settings or function() end

    local cmd       = "bluetoothctl show | sed -n -e '/PowerState:/p' -e '/Discoverable:/p' -e '/Pairable:/p'"

    function bluetooth.update()
        helpers.async({ shell, "-c", cmd },
            function(s)
                bluetooth_now = {
                    status       = string.match(s, "PowerState: (%S+)") or "N/A",
                    discoverable = string.match(s, "Discoverable: (%S+)") or "N/A",
                    pairable     = string.match(s, "Pairable: (%S+)") or "N/A",
                }
                settings()
            end)
    end

    bluetooth.timer = helpers.newtimer("bluetooth", timeout, bluetooth.update, true, true)

    return bluetooth
end

return factory
