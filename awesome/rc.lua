pcall(require, "luarocks.loader")
local gears = require("gears")
require("awful.autofocus")

local beautiful = require("beautiful")
beautiful.init(string.format("%s/.config/awesome/theme.lua", os.getenv("HOME")))

require("main.startup")

require("functions.run_once")

require("main.layouts")

require("main.taglist")

require("main.wallpaper")


require("main.mouse")

require("main.globalkeybindings")

require("main.clientkeybindings")

require("main.rules")

require("main.signals")

-- require("desktop.spotify")
require("wibar")

require("main.autostart")

collectgarbage("setpause", 160)
collectgarbage("setstepmul", 400)

gears.timer.start_new(10, function()
    collectgarbage("step", 20000)
    return true
end)
