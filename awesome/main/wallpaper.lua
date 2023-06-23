local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")

screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

awful.screen.connect_for_each_screen(function(s) -- If wallpaper is a function, call it with the screen
    awful.spawn.easy_async_with_shell("pacwall -ug", function() end)
end)
