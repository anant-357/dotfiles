local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local vi_focus = false

client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    -- c.shape = gears.shape.rounded_rect

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

awesome.connect_signal("toggle_dashboard", function()
    beautiful.eww_dashboard = not beautiful.eww_dashboard
end)

awesome.connect_signal("toggle_wibar", function()
    for s in screen do
        s.displaybar.visible = not s.displaybar.visible
        if s.statusbar then
            s.statusbar.visible = not s.statusbar.visible
        end

        if not s.displaybar.visible then
            s.padding = {
                top = 0,
                bottom = 0,
                left = 0,
                right = 0
            }
        else
            s.padding = {
                top = -15,
                bottom = 75,
                left = 0,
                right = 0
            }
        end
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {
        raise = vi_focus
    })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

