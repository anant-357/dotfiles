local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local ruled = require("ruled")
local dpi = require("beautiful.xresources").apply_dpi

awful.rules.rules = { -- All clients will match this rule.
{
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        callback = awful.client.setslave,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        size_hints_honor = false
    }
}, {
    rule = {
        instance = "spotify"
    },
    properties = {
        tag = "    ",
        switchtotag = true
    }
}, {
    rule = {
        instance = "firefox"
    },
    properties = {
        tag = "  󰈹  ",
        switchtotag = true
    }
}
-- , {
--     rule = {
--         instance = "kitty"
--     },
--     properties = {
--         tag = "    ",
--         switchtotag = true
--     }
-- }
}

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    ruled.client.append_rule {
        id = "titlebars",
        rule_any = {
            type = {"normal", "dialog"}
        },
        properties = {
            titlebars_enabled = true
        }
    }
end)

----- Titlebar
local get_titlebar = function(c)
    -- Button
    local buttons = gears.table.join({awful.button({}, 1, function()
        c:activate{
            context = "titlebar",
            action = "mouse_move"
        }
    end), awful.button({}, 3, function()
        c:activate{
            context = "titlebar",
            action = "mouse_resize"
        }
    end)})

    -- Titlebar's decorations
    local left = wibox.widget {
        awful.titlebar.widget.closebutton(c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.minimizebutton(c),
        spacing = dpi(6),
        layout = wibox.layout.fixed.horizontal
    }

    local middle = wibox.widget {
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal
    }

    local right = wibox.widget {
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal
    }

    local container = wibox.widget {
        bg = beautiful.bg,
        widget = wibox.container.background
    }

    c:connect_signal("focus", function()
        container.bg = beautiful.bg
    end)
    c:connect_signal("unfocus", function()
        container.bg = beautiful.bg
    end)

    return wibox.widget {
        {
            {
                left,
                middle,
                right,
                layout = wibox.layout.align.horizontal
            },
            margins = {
                top = dpi(12),
                bottom = dpi(12),
                left = dpi(10),
                right = dpi(10)
            },
            widget = wibox.container.margin
        },
        widget = container
    }
end

local function top(c)
    local titlebar = awful.titlebar(c, {
        position = 'top',
        size = dpi(40)
    })

    titlebar:setup{
        widget = get_titlebar(c)
    }
end

client.connect_signal("request::titlebars", function(c)
    if c.class == "feh" then
        awful.titlebar.hide(c)
    else
        top(c)
    end
end)
