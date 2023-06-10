local helpers = require("backend.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string
local type    = type

-- PulseAudio volume

local function factory(args)
    args                  = args or {}

    local microphone      = { widget = args.widget or wibox.widget.textbox(), device = "N/A" }
    local timeout         = args.timeout or 2
    local settings        = args.settings or function() end

    microphone.devicetype = args.devicetype or "source"
    microphone.cmd        = args.cmd or
    "pacmd list-" ..
    microphone.devicetype ..
    "s | sed -n -e '/*/,$!d' -e '/index/p' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p' -e '/device\\.string/p'"

    function microphone.update()
        helpers.async({ shell, "-c", type(microphone.cmd) == "string" and microphone.cmd or microphone.cmd() },
            function(s)
                volume_now = {
                    index  = string.match(s, "index: (%S+)") or "N/A",
                    device = string.match(s, "device.string = \"(%S+)\"") or "N/A",
                    muted  = string.match(s, "muted: (%S+)") or "N/A"
                }

                microphone.device = volume_now.index

                local ch = 1
                volume_now.channel = {}
                for v in string.gmatch(s, ":.-(%d+)%%") do
                    volume_now.channel[ch] = v
                    ch = ch + 1
                end

                volume_now.left  = volume_now.channel[1] or "N/A"
                volume_now.right = volume_now.channel[2] or "N/A"

                widget           = microphone.widget
                settings()
            end)
    end

    helpers.newtimer("microphone", timeout, microphone.update)

    return microphone
end

return factory
