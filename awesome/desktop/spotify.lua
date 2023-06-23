local awful       = require("awful")
local colors      = require("colorschemes.gruvbox")
local dpi         = require("beautiful.xresources").apply_dpi
local wibox       = require("wibox")
local screen           = awful.screen.focused()
local offsetx = dpi(300)
local offsety = dpi(500)

local spotify_box = awful.wibox({
    screen = awful.screen.focused(),
    bg = colors.background,
    fg = colors.foreground,
    x = (screen.geometry.width / 2) - (offsetx / 2) + 200,
    y = screen.geometry.height - offsety + 35,
    height = dpi(408),
    type = "desktop",
    visible = true,
    ontop = true
})

spotify_box.x     = 90
spotify_box.y     = 0
spotify_box.ontop = true
