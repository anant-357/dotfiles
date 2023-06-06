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
    "playerctl metadata | sed -n -e '/spotify xesam:title/p' -e '/spotify xesam:artist/p' -e '/spotify xesam:album /p'"

    function spotify.update()
        helpers.async({ shell, "-c", cmd }, function(f)
            spotify_now = {}
            if string.match(f, "spotify") then
                spotify_now.status = "on"
            else
                spotify_now.status = "off"
            end

            if spotify_now.status == "on" then
                spotify_now.title = string.match(f, "spotify xesam:title%s+([^\n]+)") or "N/A"
                if string.match(spotify_now.title, "Advertisment") then
                    spotify_now.album = "Spotify"
                    spotify_now.artist = "Spotify"
                else
                    spotify_now.album = string.match(f, "spotify xesam:album%s+([^\n]+)") or "N/A"
                    spotify_now.artist = string.match(f, "spotify xesam:artist%s+([^\n]+)") or "N/A"
                end

                awful.spawn.easy_async_with_shell("playerctl status", function(status)
                    spotify_now.playing = status
                end)
            end
            settings()
        end)
    end

    spotify.timer = helpers.newtimer("spotify", timeout, spotify.update, true, true)

    return spotify
end

return factory
