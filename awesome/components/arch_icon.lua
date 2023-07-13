-- Arch Icon  󰚌󰚀󰊠
local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local beautiful = require("beautiful")
local markup = require("backend.util.markup")

local function arch_icon_dynamic(args)
    local arch_icon = wibox.widget.textbox(markup.fg.color(beautiful.arch_icon_fg, args.icon or '󰚌'))
    local font_size = args.font_size or 14
    arch_icon.font = "Symbols Nerd Font Mono " .. tostring(font_size)

    local arch_icon_single = wibar_widget_enhancor(arch_icon, beautiful.arch_icon_bg)
    local arch_icon_containerized = arch_icon_single

    arch_icon_containerized:buttons(awful.util.table.join(awful.button({}, 1, function()
        awful.spawn.easy_async("code /home/zinnia/dotfiles", function(s)
        end)
    end), awful.button({}, 3, function()
    end)))

    return arch_icon_containerized
end

return arch_icon_dynamic
