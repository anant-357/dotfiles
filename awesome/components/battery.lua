local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local colors                = require("colorschemes.gruvbox")


local function baticon_function(args)
    local container_bool        = args.container or "no"
    local baticon               = wibox.widget.textbox('󰁿')

    local baticon_containerized = wibar_widget_enhancor(baticon, colors.dark_gray)

    baticon.font                = "Symbols Nerd Font Mono 12"


    local bat_status = {}

    local bat        = backend.widget.bat({
        timeout = 2,
        notify = "off",
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                if bat_now.ac_status == 1 then
                    if tonumber(bat_now.perc) == 100 then
                        baticon:set_text('')
                        baticon:set_font('Symbols Nerd Font Mono 11')
                    else
                        baticon:set_text('')
                    end
                else
                    if tonumber(bat_now.perc) > 0 and tonumber(bat_now.perc) <= 5 then
                        baticon:set_text('!')
                    elseif tonumber(bat_now.perc) > 5 and tonumber(bat_now.perc) <= 20 then
                        baticon:set_text('󰁻')
                    elseif tonumber(bat_now.perc) > 20 and tonumber(bat_now.perc) <= 30 then
                        baticon:set_text('󰁼')
                    elseif tonumber(bat_now.perc) > 30 and tonumber(bat_now.perc) <= 38 then
                        baticon:set_text('󰁽')
                    elseif tonumber(bat_now.perc) > 38 and tonumber(bat_now.perc) <= 50 then
                        baticon:set_text('󰁾')
                    elseif tonumber(bat_now.perc) > 50 and tonumber(bat_now.perc) <= 60 then
                        baticon:set_text('󰁿')
                    elseif tonumber(bat_now.perc) > 60 and tonumber(bat_now.perc) <= 85 then
                        baticon:set_text('󰂀')
                    elseif tonumber(bat_now.perc) > 85 and tonumber(bat_now.perc) <= 90 then
                        baticon:set_text('󰂁')
                    elseif tonumber(bat_now.perc) > 90 and tonumber(bat_now.perc) <= 99 then
                        baticon:set_text('󰂂')
                    else
                        baticon:set_text('')
                    end
                end
            else
                baticon:set_text('?')
            end
            bat_status = bat_now
        end
    })

    local battery_t  = awful.tooltip {
        objects = { baticon },
        bg = colors.background,
        fg = colors.foreground,
        shape = wibar_widget_shape,
        timer_function = function()
            local msg = ""
            msg = msg ..
                backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10",
                    string.format("%s %s&#37;\n", bat_status.status, bat_status.perc))
            return msg .. backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10", bat_status.time .. " left")
        end
    }
    if container_bool == "yes" then
        return baticon_containerized
    else
        return baticon
    end
end

return baticon_function
