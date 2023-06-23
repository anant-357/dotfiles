local awful = require("awful")


require("components.brightness")

require("components").volume_bar({ shape = "default", colorscheme = "default" })

awful.spawn.easy_async_with_shell("picom --config ~/dotfiles/picom/picom.conf ", function() end)
awful.spawn.easy_async_with_shell("pamixer --unmute ", function() end)
