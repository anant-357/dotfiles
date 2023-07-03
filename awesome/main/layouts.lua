local awful = require("awful")

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}
local s = awful.screen.focused()
s.padding = {
    top = -15,
    bottom = 75,
    left = 0,
    right = 0
}

-- Restore client after tiling layout
tag.connect_signal('property::layout', function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            local cgeo = awful.client.property.get(c, 'floating_geometry')
            if cgeo then
                c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
        end
    end
end)

client.connect_signal('manage', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

client.connect_signal('property::geometry', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)


local disable_titlebar = function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
            awful.titlebar.hide(c)
        else
            awful.titlebar.show(c)
        end
    end
end

tag.connect_signal('property::layout', function(t)
    disable_titlebar(t)
end)

client.connect_signal("request::manage", function(c)
    if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
        awful.titlebar.hide(c)
    else
        awful.titlebar.show(c)
    end
end)
