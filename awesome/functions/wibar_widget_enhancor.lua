local wibox              = require("wibox")
local wibar_widget_shape = require("functions.wibar_widget_shape")


local wibar_widget_enhancor = function(widget, color)
    local background_done = wibox.container.background(
        wibox.container.margin(widget, 16, 16, 4, 4),
        color,
        wibar_widget_shape
    )

    background_done.opacity = 1
    return wibox.container.margin(background_done
    , 6, 6, 10, 10)
end

return wibar_widget_enhancor
