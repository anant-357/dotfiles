-- Arch Icon  󰚌󰚀󰊠
local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local beautiful             = require("beautiful")
local gears                 = require("gears")
local markup = require("backend.util.markup")




local function user(args)
    local user_text        = wibox.widget.textbox(markup.fg.color(beautiful.user_fg," Hi " .. os.getenv("USER") .. "! ----->>"))
    local user_github      = wibox.widget.textbox(markup.fg.color(beautiful.user_fg," "))
    local height           = 30
    local width            = 30
    local user_image_shape = function(cr)
        return gears.shape.circle(cr, height, width)
    end

    local user_image       =
        wibox.container.margin(

            wibox.widget {
                image = beautiful.user_image,
                resize = true,
                widget = wibox.widget.imagebox,
                clip_shape = user_image_shape,
                forced_width = width,
                forced_height = height
            },
            -6, 0, 1, 0
        )


    local font_size  = 12
    user_text.font   = "Fira Code, Bold " .. tostring(font_size)
    user_github.font = "Symbols Nerd Font Mono 20 "


    local user_containerized =
        wibar_widget_enhancor(
            wibox.widget { user_image, user_text, user_github, layout = wibox.layout.fixed.horizontal }
            , beautiful.user_bg)

    user_github:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn.easy_async("xdg-open https://github.com/anant-357", function(s) end)
        end)
    -- ,
    -- awful.button({}, 3, function()
    -- end)
    ))

    return user_containerized
end

return user
