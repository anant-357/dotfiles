pcall(require, "luarocks.loader")

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
