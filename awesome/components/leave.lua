
-- logout -- 󰑮󰭔󰯧⏻


local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local colors                = require("colorschemes.gruvbox")


local function leaveicon_function(args)
    local container_bool              = args.container or "no"
    local leave_icon               = wibox.widget.textbox('󰐦')
    local leave_icon_containerized = wibar_widget_enhancor(leave_icon, colors.dark_red)
    leave_icon.font                = "Symbols Nerd Font Mono 11"

    leave_icon_containerized:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn("sh /home/vix/.config/rofi/powermenu/powermenu.sh")
        end)
    ))
    if container_bool == "yes" then
        return leave_icon_containerized
    else
        return leave_icon
    end
end

return leaveicon_function
