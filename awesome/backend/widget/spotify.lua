local helpers = require("backend.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string
local awful   = require("awful")


local function factory(args)
    args           = args or {}

    local spotify  = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    local cmd      =
    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'"

    function spotify.update()
        helpers.async({ shell, "-c", cmd }, function(f)
            spotify_now = {}
            if string.match(f, "method return time") then
                spotify_now.status = "on"
            else
                spotify_now.status = "off"
            end

            if spotify_now.status == "on" then
                spotify_now.title = f:match('string "xesam:title"%s-variant%s-string "(.-)"') or "N/A"
                if string.match(spotify_now.title, "Advertisment") then
                    spotify_now.album = "Spotify"
                    spotify_now.artist = "Spotify"
                else
                    spotify_now.album = f:match('string "xesam:album"%s-variant%s-string "(.-)"') or "N/A"
                    spotify_now.artist = f:match('string "xesam:artist"%s-variant%s-array %[%s-string "(.-)"%s-%]') or
                        "N/A"
                end

                awful.spawn.easy_async_with_shell(
                    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus'",
                    function(status)
                        spotify_now.playing = status:match('variant%s-string "(.-)"')
                    end)
            end
            settings()
        end)
    end

    spotify.timer = helpers.newtimer("spotify", timeout, spotify.update, true, true)

    return spotify
end

return factory
