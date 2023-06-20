local awful   = require("awful")
local wibox   = require("wibox")
local colors  = require("colorschemes.gruvbox")

local gears   = require("gears")
local dpi     = require("beautiful").xresources.apply_dpi
local format  = string.format
local offsetx = dpi(320)
local offsety = dpi(100)
local screen  = awful.screen.focused()


local function factory(args)
    args = args or {}

    local bar_shape = args.shape or "default"
    local colorscheme = args.colorscheme or "default"
    local foreground
    local background

    if colorscheme == "inverted" then
        foreground = colors.background
        background = colors.foreground
    else
        foreground = colors.foreground
        background = colors.background
    end

    local volume_bar_icon
    local volume_bar_adjust
    local volume_bar_bar
    local mute_icon

    if bar_shape == "rounded" then
        local volume_bar_adjust_shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 48)
        end
        local markup                  = require("backend.util.markup")

        volume_bar_icon               = wibox.widget.textbox(markup.fontfg("Symbols Nerd Font Mono 16", foreground,
            ""))
        mute_icon                     = wibox.widget.textbox("󰍯")

        volume_bar_icon.font          = "Symbols Nerd Font Mono 16"
        mute_icon.font                = "Symbols Nerd Font Mono 16"


        -- create the volume_bar_adjust component
        volume_bar_adjust = wibox({
            screen = awful.screen.focused(),
            x = (screen.geometry.width / 2) - (offsetx / 2),
            y = screen.geometry.height - offsety,
            height = dpi(42),
            width = offsetx,
            visible = false,
            ontop = true
            ,
            shape = volume_bar_adjust_shape,
            type = "notification",
            border_width = 4,
            border_color = background,
        })

        volume_bar_bar    = wibox.widget {
            widget = wibox.widget.progressbar,
            height = dpi(42),
            color = colors.foreground,
            background_color = colors.dark_gray,
            max_value = 200,
            value = 0,
            shape = volume_bar_adjust_shape

        }



        volume_bar_adjust:setup {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,

                wibox.container.background(
                    volume_bar_bar,
                    colors.background
                ),
                forced_width = offsetx

            },
            wibox.container.margin(
                mute_icon, dpi(20), dpi(22), dpi(0), dpi(0)
            ),
            wibox.container.margin(
                volume_bar_icon, dpi(40), dpi(0), dpi(0), dpi(0)
            )
        }
    else
        volume_bar_icon = wibox.widget.textbox("")
        mute_icon = wibox.widget.textbox("󰍯")

        volume_bar_icon.font = "Symbols Nerd Font Mono 16"
        mute_icon.font = "Symbols Nerd Font Mono 16"


        -- create the volume_bar_adjust component
        volume_bar_adjust = wibox({
            screen = awful.screen.focused(),
            x = (screen.geometry.width / 2) - (offsetx / 2),
            y = screen.geometry.height - offsety,
            height = dpi(48),
            width = offsetx,
            visible = false,
            ontop = true
        })

        volume_bar_bar = wibox.widget {
            widget = wibox.widget.progressbar,
            color = colors.foreground,
            background_color = colors.dark_gray,
            max_value = 200,
            value = 0
        }

        volume_bar_adjust:setup {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.align.horizontal,
                wibox.container.background(

                    wibox.container.margin(
                        volume_bar_bar, dpi(14), dpi(4), dpi(20), dpi(20)
                    ), colors.background
                ),
                forced_width = 0.7 * offsetx

            },

            wibox.container.background(

                wibox.container.margin(
                    volume_bar_icon, dpi(0), dpi(0), dpi(0), dpi(0)
                ), colors.background
            ),
            wibox.container.background(

                wibox.container.margin(
                    mute_icon, dpi(0), dpi(22), dpi(0), dpi(0)
                ), colors.background
            )
        }
    end

    local hide_volume_bar_adjust = gears.timer {
        timeout = 2,
        autostart = true,
        callback = function()
            volume_bar_adjust.visible = false
        end
    }

    awesome.connect_signal("volume_bar_change",
        function()
            awful.spawn.easy_async_with_shell('pamixer --get-volume',
                function(stdout)
                    local volume_bar_level = tonumber(stdout)
                    volume_bar_bar.value = volume_bar_level
                    if (volume_bar_level == nil) then
                    elseif (volume_bar_level >= 150) then
                        volume_bar_icon:set_markup_silently(format("<span foreground='%s'>  󰕿</span>",
                            foreground))
                    elseif (volume_bar_level >= 100) then
                        volume_bar_icon:set_markup_silently(format("<span foreground='%s'>  󰕿</span>",
                            foreground))
                    elseif (volume_bar_level >= 50) then
                        volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰕾</span>",
                            foreground))
                    elseif (volume_bar_level > 0) then
                        volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰖀</span>",
                            foreground))
                    else
                        volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰕿</span>",
                            foreground))
                    end
                end,
                false
            )
            awful.spawn.easy_async_with_shell('pamixer --get-mute',
                function(stdout)
                    if (string.match(tostring(stdout), "true")) then
                        volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰖁</span>",
                            foreground))
                    end
                end,
                false
            )
            awful.spawn.easy_async_with_shell("amixer get Capture | grep -oF '[on]' | head -n 1",
                function(stdout)
                    if (string.match(tostring(stdout), "on")) then
                        mute_icon:set_markup_silently(format("<span foreground='%s'>󰍬</span>", foreground))
                    else
                        mute_icon:set_markup_silently(format("<span foreground='%s'>󰍭</span>", foreground))
                    end
                end,
                false
            )

            -- make volume_bar_adjust component visible
            if volume_bar_adjust.visible then
                hide_volume_bar_adjust:again()
            else
                volume_bar_adjust.visible = true
                hide_volume_bar_adjust:start()
            end
        end
    )
end

return factory
