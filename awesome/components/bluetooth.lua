local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend                  = require("backend")
local colors                = require("colorschemes.gruvbox")


local function bluetooth_icon_function(args)
    local container_bool               = args.container or "no"
    local bluetooth_icon               = wibox.widget.textbox('󰂱')
    bluetooth_icon.font                = "Symbols Nerd Font Mono 12"

    local bluetooth_status             = {}

    local bluetooth_icon_containerized = wibar_widget_enhancor(bluetooth_icon, colors.dark_blue)

    local bluetooth                    = backend.widget.bluetooth({
        timeout = 1,
        settings = function()
            if bluetooth_now.status == "on" then
                bluetooth_icon:set_text("󰂯")
            else
                bluetooth_icon:set_text("󰂲")
            end
            bluetooth_status = bluetooth_now
        end
    })

    bluetooth_icon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            if bluetooth_status.status == "on" then
                awful.util.spawn("bluetoothctl power off")
            else
                awful.util.spawn("bluetoothctl power on")
            end
        end)
    ))
    if container_bool == "yes" then
        return bluetooth_icon_containerized
    else
        return bluetooth_icon
    end
end

return bluetooth_icon_function
