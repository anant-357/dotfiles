naughty = require("naughty")
gears = require("gears")
naughty.config.presets.spotify = {
    callback = function(args)
        return true
    end,
    height = 100,
    width = 300,
    icon_size = 90,
    icon_shape = gears.shape.circle
}
table.insert(naughty.dbus.config.mapping, {{
    appname = "Spotify"
}, naughty.config.presets.spotify})
