-- Arch Icon  󰚌󰚀󰊠
local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local colors                = require("colorschemes.gruvbox")

local function screenshot_icon(args)
    local container_bool                = args.container or "no"
    local screenshot_icon               = wibox.widget.textbox('󰆟')
    screenshot_icon.font                = "Symbols Nerd Font Mono 12"

    local screenshot_icon_containerized = wibar_widget_enhancor(screenshot_icon, colors.dark_purple)

    screenshot_icon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn("scrot -s -e 'xclip -selection clipboard -t image/png -i $f'")
        end)
    ))

    if container_bool == "yes" then
        return screenshot_icon_containerized
    else
        return screenshot_icon
    end
end

return screenshot_icon
