local wibox = require("wibox")
local awful = require("awful")
local backend = require("backend")


local add_tag = wibox.widget.textbox(" ")
add_tag.font = "Symbols Nerd Font Mono 8"

add_tag:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        backend.util.add_tag()
    end)
))

return add_tag
