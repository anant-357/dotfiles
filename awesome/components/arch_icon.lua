-- Arch Icon  󰚌󰚀󰊠
local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local colors                = require("colorschemes.gruvbox")

local function arch_icon_dynamic(args)
    local arch_icon            = wibox.widget.textbox(args.icon or '󰚌')
    arch_icon.font             = "Symbols Nerd Font Mono 12"

    local arch_icon_containers = args.containers or "double"



    local arch_icon_status = "mask"

    local arch_icon_single = wibar_widget_enhancor(arch_icon, colors.dark_aqua)
    local arch_icon_double = wibar_widget_enhancor(
        wibar_widget_enhancor(arch_icon, "#1d2021"), colors.dark_gray

    )
    local arch_icon_containerized
    if arch_icon_containers == "single" then
        arch_icon_containerized = arch_icon_single
    else
        arch_icon_containerized = arch_icon_double
    end

    arch_icon_containerized:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn.easy_async("code /home/vix/dotfiles", function(s) end)
        end),
        awful.button({}, 3, function()
            if arch_icon_status == "mask" then
                arch_icon_containerized = arch_icon_single
                arch_icon_status = "unmask"
            else
                arch_icon_containerized = arch_icon_double
                arch_icon_status = "mask"
            end
        end)
    ))

    return arch_icon_containerized
end

return arch_icon_dynamic
