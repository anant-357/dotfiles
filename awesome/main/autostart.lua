local awful = require("awful")


awful.spawn.easy_async("pkill picom")
require("components.brightness")

require("components").volume_bar({ shape = "default", colorscheme = "default" })
awful.spawn.easy_async_with_shell("pamixer --unmute ", function() end)
awesome.emit_signal("volume_change")
awful.spawn.easy_async_with_shell("picom --config ~/dotfiles/picom/picom.conf ", function() end)
