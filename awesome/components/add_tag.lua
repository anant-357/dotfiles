local wibox = require("wibox")
local awful = require("awful")
local backend = require("backend")

local add_tag = wibox.widget.textbox(" ")
add_tag.font = "Symbols Nerd Font Mono 10"

add_tag:buttons(awful.util.table.join(awful.button({}, 1, function()
    backend.util.add_tag()
end)))

local add_tag_t = awful.tooltip {
    objects = {add_tag},
    margins = 10,
    timer_function = function()
        return "Add new tag"
    end
}

return add_tag
