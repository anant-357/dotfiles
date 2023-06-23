local gears   = require("gears")
local awful   = require("awful")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

root.buttons(mytable.join(
    -- awful.button({}, 3, ""),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
