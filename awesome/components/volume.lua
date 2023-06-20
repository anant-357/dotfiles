local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local colors                = require("colorschemes.gruvbox")



local function volicon_function(args)
    local container_bool        = args.container or "no"

    local volicon               = wibox.widget.textbox(' 󰖁 ')
    local volicon_containerized = wibar_widget_enhancor(volicon, colors.dark_gray)
    volicon.font                = "Symbols Nerd Font Mono 11"
    local volume_status         = {}
    local volume                = backend.widget.pulse({
        timeout = 0.1,
        settings = function()
            if volume_now.muted == "yes" then
                volicon:set_text(" 󰖁 ")
            elseif tonumber(volume_now.left) + tonumber(volume_now.right) == 0 then
                volicon:set_text(" 󰕿 ")
            elseif tonumber(volume_now.left) + tonumber(volume_now.right) <= 100 then
                volicon:set_text(" 󰖀 ")
            elseif tonumber(volume_now.left) + tonumber(volume_now.right) <= 200 then
                volicon:set_text(" 󰕾 ")
            elseif tonumber(volume_now.left) + tonumber(volume_now.right) <= 300 then
                volicon:set_text("󰕿")
            else
                volicon:set_text("󰕿")
            end
            -- volicon:set_text(tostring(volume_now.left))

            volume_status = volume_now
        end
    })

    local volume_t              = awful.tooltip {
        objects = { volicon },
        bg = colors.background,
        fg = colors.foreground,
        shape = wibar_widget_shape,
        timer_function = function()
            return backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10",
                string.format("Volume: %s&#37;\n", volume_status.left))
        end
    }

    volicon:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.util.spawn("pamixer --toggle-mute")
        end)
    ))
    if container_bool == "yes" then
        return volicon_containerized
    else
        return volicon
    end
end

return volicon_function
