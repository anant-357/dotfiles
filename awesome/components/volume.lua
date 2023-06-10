local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local colors                = require("colorschemes.gruvbox")

local gears                 = require("gears")
local dpi                   = require("beautiful").xresources.apply_dpi
local format                = string.format
local offsetx               = dpi(320)
local offsety               = dpi(100)
local screen                = awful.screen.focused()


local volume_bar_icon = wibox.widget.textbox("")
local mute_icon = wibox.widget.textbox("󰍯")

volume_bar_icon.font = "Symbols Nerd Font Mono 16"
mute_icon.font = "Symbols Nerd Font Mono 16"


-- create the volume_bar_adjust component
local volume_bar_adjust = wibox({
    screen = awful.screen.focused(),
    x = (screen.geometry.width / 2) - (offsetx / 2),
    y = screen.geometry.height - offsety,
    height = dpi(48),
    width = offsetx,
    visible = false,
    ontop = true
})

local volume_bar_bar = wibox.widget {
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

-- create a 2 second timer to hide the volume_bar adjust
-- component whenever the timer is started
local hide_volume_bar_adjust = gears.timer {
    timeout = 2,
    autostart = true,
    callback = function()
        volume_bar_adjust.visible = false
    end
}

-- show volume_bar-adjust when "volume_bar_change" signal is emitted
awesome.connect_signal("volume_bar_change",
    function()
        awful.spawn.easy_async_with_shell('pamixer --get-volume',
            function(stdout)
                local volume_bar_level = tonumber(stdout)
                volume_bar_bar.value = volume_bar_level
                if (volume_bar_level == nil) then
                elseif (volume_bar_level >= 150) then
                    volume_bar_icon:set_markup_silently(format("<span foreground='%s'>  󰕿</span>",
                        colors.foreground))
                elseif (volume_bar_level >= 100) then
                    volume_bar_icon:set_markup_silently(format("<span foreground='%s'>  󰕿</span>",
                        colors.foreground))
                elseif (volume_bar_level >= 50) then
                    volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰕾</span>", colors.foreground))
                elseif (volume_bar_level > 0) then
                    volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰖀</span>", colors.foreground))
                else
                    volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰕿</span>", colors.foreground))
                end
            end,
            false
        )
        awful.spawn.easy_async_with_shell('pamixer --get-mute',
            function(stdout)
                if (string.match(tostring(stdout), "true")) then
                    volume_bar_icon:set_markup_silently(format("<span foreground='%s'>   󰖁</span>", colors.foreground))
                end
            end,
            false
        )
        awful.spawn.easy_async_with_shell("amixer get Capture | grep -oF '[on]' | head -n 1",
            function(stdout)
                if (string.match(tostring(stdout), "on")) then
                    mute_icon:set_markup_silently(format("<span foreground='%s'>󰍬</span>", colors.foreground))
                else
                    mute_icon:set_markup_silently(format("<span foreground='%s'>󰍭</span>", colors.foreground))
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
