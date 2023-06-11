local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local colors                = require("colorschemes.gruvbox")

local function rgb_keyboard_icon(args)
    local container_bool                  = args.container or "no"
    local rgb_keyboard_icon               = wibox.widget.textbox(' ')
    rgb_keyboard_icon.font                = "Symbols Nerd Font Mono 14"

    local rgb_keyboard_icon_containerized = wibar_widget_enhancor(rgb_keyboard_icon, colors.dark_purple)

    rgb_keyboard_icon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn.easy_async("rgb_config_acer_gkbbl_0", function() end)
        end)
    ))

    if container_bool == "yes" then
        return rgb_keyboard_icon_containerized
    else
        return rgb_keyboard_icon
    end
end

return rgb_keyboard_icon
