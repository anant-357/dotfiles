-- logout -- 󰑮󰭔󰯧⏻
local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local beautiful = require("beautiful")
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local markup = require("backend.util.markup")

local mood_table = {"", "󰻀", "󱗎", "󰂾", "󰥟", "󰲓"}
local mood = mood_table[beautiful.mood_index]

local function moodicon_function(args)
    local container_bool = args.container or "no"
    local font_size = args.font_size or 12
    local mood_icon = wibox.widget.textbox(markup.fg.color(beautiful.mood_fg, mood)) -- | 
    local mood_icon_containerized = wibar_widget_enhancor(mood_icon, beautiful.mood_bg)
    mood_icon.font = "Symbols Nerd Font Mono " .. tostring(font_size)

    mood_icon:buttons(awful.util.table.join(awful.button({}, 1, function()
        beautiful.mood_index = ((beautiful.mood_index + 1) % 6)
        mood_icon:set_markup_silently(markup.fg.color(beautiful.mood_fg, mood_table[beautiful.mood_index + 1]))
        mood_icon:emit_signal("widget::redraw_needed")
    end)))

    if container_bool == "yes" then
        return mood_icon_containerized
    else
        return mood_icon
    end
end

return moodicon_function
