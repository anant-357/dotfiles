local helpers = require("backend.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string


local function factory(args)
    args           = args or {}

    local webcam   = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    local cmd      = "fuser -v /dev/video0"

    function webcam.update()
        helpers.async({ shell, "-c", cmd }, function(f)
            webcam_now = {
            }
            if string.match(f, "Specified") then
                webcam_now.status = "off"
            elseif string.match(f, "PID") then
                webcam_now.status = "on"
            else
                webcam_now.status = "avail"
            end
            settings()
        end)
    end

    webcam.timer = helpers.newtimer("webcam", timeout, webcam.update, true, true)

    return webcam
end

return factory
