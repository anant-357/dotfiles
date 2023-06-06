local gears = require("gears")


local wibar_widget_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end

return wibar_widget_shape
