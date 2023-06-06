local wibox              = require("wibox")
local wibar_widget_shape = require("functions.wibar_widget_shape")


local wibar_widget_enhancor = function(widget, color)
    local background_done = wibox.container.background(
        wibox.container.margin(widget, 4, 4, 2, 2),
        color,
        wibar_widget_shape
    )

    background_done.opacity = 0.85
    return wibox.container.margin(background_done
    , 0, 0, 5, 5)
end

return wibar_widget_enhancor
