local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local beautiful             = require("beautiful")


local function webcam_function(args)
    local container_bool       = args.container or "no"
    local webcam_icon          = wibox.widget.textbox("")
    webcam_icon.font           = "Symbols Nerd Font Mono 10"

    local webcam_containerized = wibar_widget_enhancor(webcam_icon, beautiful.webcam_bg)

    local webcam_status        = {}
    --󰈈󰈉󰛐󰛑
    local webcam               = backend.widget.webcam({
        timeout = 1,
        settings = function()
            if webcam_now.status == "off" then
                webcam_icon:set_text("")
                webcam_icon.font = "Symbols Nerd Font Mono 12"
            else
                webcam_icon:set_text("")
                webcam_icon.font = "Symbols Nerd Font Mono 12"
            end
            webcam_status = webcam_now
        end
    })

    webcam_icon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            if webcam_status.status == "off" then
                awful.util.spawn("sudo modprobe uvcvideo")
            else
                awful.util.spawn("sudo rmmod -f uvcvideo")
            end
        end)
    ))

    local webcam_t = awful.tooltip {
        objects = { webcam_icon },
        shape = wibar_widget_shape,
        timer_function = function()
            if webcam_status.status == "off" then
                return backend.util.markup.font("Fira Code, Medium 10", "Webcam Off")
            end
            return backend.util.markup.font("Fira Code, Medium 10", "Webcam On")
            -- return webcam_status.status
        end

    }
    if container_bool == "yes" then
        return webcam_containerized
    else
        return webcam_icon
    end
end

return webcam_function
