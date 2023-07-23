local awful = require("awful")
require("components.brightness")
require("components").volume_bar({
    shape = "default",
    colorscheme = "default"
})
awesome.emit_signal("volume_change")

awful.spawn.easy_async("pkill picom")

awful.spawn.easy_async("kill -9 $(pidof redshift)")

awful.spawn.easy_async("buckle")


awful.spawn.easy_async_with_shell("picom --config ~/dotfiles/picom/picom.conf ", function()
end)

awful.spawn.easy_async("redshift -l 26.08:96.51  -t 5800K:4000K -g 0.8")
