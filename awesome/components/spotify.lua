local awful = require("awful")
local wibox = require("wibox")
local functions = require("functions")
local wibar_widget_enhancor = functions.wi_widget_enhancor
local wibar_widget_shape = functions.wi_widget_shape
local backend = require("backend")
local beautiful = require("beautiful")
local markup = require("backend.util.markup")

local spr = wibox.widget.textbox(' ')

local spotify_icon = wibox.widget.textbox(markup.fg.color(beautiful.spotify_fg, "󰽳"))
spotify_icon.font = "Symbols Nerd Font Mono 11"

local spotify_next_song_icon = wibox.widget.textbox(markup.fg.color(beautiful.spotify_fg, "󰍟"))
spotify_next_song_icon.font = "Symbols Nerd Font Mono 11"

local spotify_prev_song_icon = wibox.widget.textbox(markup.fg.color(beautiful.spotify_fg, "󰍞"))
spotify_prev_song_icon.font = "Symbols Nerd Font Mono 11"

local spotify_all = wibox.widget {
    spotify_prev_song_icon,
    spr,
    spotify_icon,
    spr,
    spotify_next_song_icon,
    layout = wibox.layout.fixed.horizontal
}

local spotify_all_containerized = wibar_widget_enhancor(spotify_all, beautiful.spotify_bg)

local spot_t_now = {}

local spotify = backend.widget.spotify({
    timeout = 1,
    settings = function()
        if spotify_now.status == "on" then
            spotify_icon:set_markup_silently(markup.fg.color(beautiful.spotify_fg, ""))
            spotify_icon.font = "Symbols Nerd Font Mono 12"
        else
            spotify_icon:set_markup_silently(markup.fg.color(beautiful.spotify_fg, "󰽳"))
            spotify_icon.font = "Symbols Nerd Font Mono 10"
        end
        spot_t_now = spotify_now
    end
})

spotify_icon:buttons(awful.util.table.join(awful.button({}, 1, function()
    if spot_t_now.status == "on" then
        awful.spawn.easy_async(
            "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause",
            function()
            end)
    else
        awful.spawn.easy_async("spotify", function()
        end)
    end
end)))

spotify_next_song_icon:buttons(awful.util.table.join(awful.button({}, 1, function()
    awful.spawn.easy_async(
        "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next",
        function()
        end)
end)))

spotify_prev_song_icon:buttons(awful.util.table.join(awful.button({}, 1, function()
    awful.spawn.easy_async(
        "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous",
        function()
        end)
end)))

local spotify_t = awful.tooltip {
    objects = {spotify_icon},
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
    objects = {spotify_next_song_icon},
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
    objects = {spotify_prev_song_icon},
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
