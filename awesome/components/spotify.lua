local awful                 = require("awful")
local wibox                 = require("wibox")
local functions             = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape    = functions.wi_widget_shape
local backend               = require("backend")
local colors                = require("colorschemes.gruvbox")
local spr                   = wibox.widget.textbox(' ')


local spotify_icon           = wibox.widget.textbox("󰽳")
spotify_icon.font            = "Symbols Nerd Font Mono 10"

local spotify_next_song_icon = wibox.widget.textbox("󰍟")
spotify_next_song_icon.font  = "Symbols Nerd Font Mono 10"

local spotify_prev_song_icon = wibox.widget.textbox("󰍞")
spotify_prev_song_icon.font  = "Symbols Nerd Font Mono 10"


local spotify_all = wibox.widget {
    spotify_prev_song_icon,
    spr,
    spotify_icon,
    spr,
    spotify_next_song_icon,
    layout = wibox.layout.fixed.horizontal
}


local spotify_all_containerized = wibar_widget_enhancor(spotify_all, colors.dark_green)

local spot_t_now                = {}

local spotify                   = backend.widget.spotify({
    timeout = 1,
    settings = function()
        if spotify_now.status == "on" then
            spotify_icon:set_text("")
            spotify_icon.font = "Symbols Nerd Font Mono 12"
        else
            spotify_icon:set_text("󰽳")
            spotify_icon.font = "Symbols Nerd Font Mono 10"
        end
        spot_t_now = spotify_now
    end
})

spotify_icon:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        if spot_t_now.status == "on" then
            awful.util.spawn("playerctl play-pause")
        else
            awful.spawn.easy_async("spotify")
        end
    end)
))

spotify_next_song_icon:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.util.spawn("playerctl next")
    end)
))

spotify_prev_song_icon:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.util.spawn("playerctl previous")
    end)
))


local spotify_t           = awful.tooltip {
    objects = { spotify_icon },
    bg = colors.background,
    fg = colors.foreground,
    shape = wibar_widget_shape,
    timer_function = function()
        if spot_t_now.status == "off" then
            return backend.util.markup.font("Fira Code, Medium 10", "Spotify not running")
        end
        local ret = backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10",
            string.format("Song: %s\nArtist: %s\nAlbum: %s\n%s", spot_t_now.title, spot_t_now.artist, spot_t_now.album,
                spot_t_now.playing))
        return ret
    end
}

local spotify_next_song_t = awful.tooltip {
    objects = { spotify_next_song_icon },
    bg = colors.background,
    fg = colors.foreground,
    shape = wibar_widget_shape,
    timer_function = function()
        if spot_t_now.status == "off" then
            return backend.util.markup.font("Fira Code, Medium 10", "Spotify not running")
        end
        local ret = backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10", "Next Song")
        return ret
    end
}

local spotify_prev_song_t = awful.tooltip {
    objects = { spotify_prev_song_icon },
    bg = colors.background,
    fg = colors.foreground,
    shape = wibar_widget_shape,
    timer_function = function()
        if spot_t_now.status == "off" then
            return backend.util.markup.font("Fira Code, Medium 10", "Spotify not running")
        end
        local ret = backend.util.markup.font("FiraCode Nerd Font Mono, Medium 10", "Previous Song")
        return ret
    end
}

return spotify_all_containerized
