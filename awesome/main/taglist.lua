local gears   = require("gears")
local awful   = require("awful")
local modkey  = "Mod4"
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility


awful.util.tagnames        = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 " }

awful.util.taglist_buttons = mytable.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)
