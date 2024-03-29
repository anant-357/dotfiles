local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local beautiful = require("beautiful")
local markup = require("backend.util.markup")

local function baticon_function(args)
    local container_bool = args.container or "no"
    local font_size = args.font_size or 12

    local battext = wibox.widget.textbox(markup.fg.color(beautiful.battery_fg, '󰁿'))
    local baticon = wibox.widget {
        widget = wibox.widget.progressbar,
        forced_height = 10,
        forced_width = 18,
        color = beautiful.battery_fg,
        background_color = beautiful.battery_bg,
        max_value = 100,
        value = 0
    }

    local spr = wibox.widget.textbox(backend.util.markup.font("FiraCode Nerd Font Mono, Medium 3", " "))

    local bat_status = {}

    local bat = backend.widget.bat({
        timeout = 2,
        notify = "off",
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                baticon:set_value(bat_now.perc)

                if bat_now.ac_status == 1 then
                    beautiful.discharge_flag = false
                    if tonumber(bat_now.perc) == 100 then
                        battext:set_markup_silently(markup.fg.color(beautiful.battery_fg, ' 󱐱'))
                        battext:set_font('Symbols Nerd Font Mono,10')
                    else
                        battext:set_markup_silently(markup.fg.color(beautiful.battery_fg, ' '))
                        battext:set_font('Symbols Nerd Font Mono ' .. tostring(font_size))
                    end
                else
                    if beautiful.discharge_flag == false then
                        naughty.notify({
                            fg = beautiful.foreground,
                            bg = beautiful.background,
                            title = "   󰂍 ",
                            text = " Discharging ",
                            border_width = 0
                        })
                        beautiful.discharge_flag = true
                    end

                    local critical_perc = 15

                    if tonumber(bat_now.perc) <= critical_perc and beautiful.critical_battery_flag == false then
                        naughty.notify({
                            fg = beautiful.foreground,
                            bg = beautiful.background,
                            title = "   󱃍 ",
                            text = " Battery level critical - " .. tostring(bat_now.perc) .. "% ",
                            border_width = 0
                        })
                        beautiful.critical_battery_flag = true
                    elseif tonumber(bat_now.perc) == critical_perc + 1 or tonumber(bat_now.perc) == critical_perc - 1 then
                        beautiful.critical_battery_flag = false
                    end

                    battext:set_markup_silently(markup.fg.color(beautiful.battery_fg, ' '))
                    battext:set_font('Symbols Nerd Font Mono 5')
                end
            else
                battext:set_markup_silently(markup.fg.color(beautiful.battery_fg, ' ?'))
            end
            bat_status = bat_now
        end
    })
    local baticon_containerized = wibar_widget_enhancor(baticon, beautiful.battery_bg)

    local battery_t = awful.tooltip {
        objects = {baticon},
    margins = 10,
    timer_function = function()
            return string.format("%s %s&#37;\n", bat_status.status, bat_status.perc) .. bat_status.time .. " left"
        end
    }
    if container_bool == "yes" then
        return baticon_containerized
    else
        return wibox.widget {
            layout = wibox.layout.align.horizontal,

            {
                id = "alignly",
                widget = wibox.container.place,
                halign = "center",
                {
                    widget = wibox.container.rotate,
                    baticon,
                    direction = "east"
                }
            },
            spr,
            {
                widget = wibox.container.place,
                halign = "center",
                battext
            }
        }
    end
end

return baticon_function
