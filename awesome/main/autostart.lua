local awful = require("awful")
require("components.brightness")
require("components").volume_bar({
    shape = "default",
    colorscheme = "default"
})
awesome.emit_signal("volume_change")

awful.spawn.easy_async_with_shell("pkill buckle; buckle", function()
end)

awful.spawn.easy_async_with_shell("pkill picom; picom --experimental-backends --config ~/dotfiles/picom/picom.conf ",
    function()
    end)
awful.spawn.easy_async_with_shell("wal -R", function()

end)

-- awful.spawn.easy_async_with_shell("redshift -l 26.08:96.51  -t 5800K:4000K -g 0.8", function()
-- end)
