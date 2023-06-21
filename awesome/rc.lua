-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local backend       = require("backend")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function(err)
        if in_error then return end

        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }

        in_error = false
    end)
end



-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "urxvtd", "unclutter -root" })


local modkey         = "Mod4"
local altkey         = "Mod1"
local terminal       = "kitty"
local vi_focus       = false
local cycle_prev     = true
local editor         = os.getenv("EDITOR") or "nvim"
local browser        = "firefox"

awful.util.terminal  = terminal
awful.util.tagnames  = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 " }
awful.layout.layouts = {
    awful.layout.suit.tile,          -- 󰢡
    awful.layout.suit.spiral.name,   -- 󰥋
    awful.layout.suit.spiral.dwindle -- 󰟝
}


awful.util.taglist_buttons = mytable.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

beautiful.init(string.format("%s/.config/awesome/theme.lua", os.getenv("HOME")))

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

require("wibar")



-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) -- If wallpaper is a function, call it with the screen
    awful.spawn.easy_async_with_shell("pacwall -ug", function() end)
end)


-- }}}

-- {{{ Mouse bindings

root.buttons(mytable.join(
    awful.button({}, 3, ""),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = mytable.join(
-- Destroy all notifications
    awful.key({ "Control", }, "space", function() naughty.destroy_all_notifications() end,
        { description = "destroy all notifications", group = "hotkeys" }),

    -- X screen locker
    awful.key({ modkey }, "l", function() awful.spawn("betterlockscreen_rapid 20 1") end,
        { description = "lock screen", group = "hotkeys" }),

    awful.key({ modkey, "Shift" }, "l", function()
            awful.spawn.easy_async("sh /home/vix/.config/rofi/powermenu/powermenu.sh", function() end)
        end,
        { description = "exit menu", group = "hotkeys" }),


    -- Show help
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),

    -- Tag browsing
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function() backend.util.tag_view_nonempty(-1) end,
        { description = "view  previous nonempty", group = "tag" }),
    awful.key({ altkey }, "Right", function() backend.util.tag_view_nonempty(1) end,
        { description = "view  previous nonempty", group = "tag" }),

    -- Default client focus
    awful.key({ altkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ altkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    -- By-direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client" }),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client" }),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Tab",
        function()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "cycle with previous/go back", group = "client" }),

    -- Show/hide wibox
    awful.key({ modkey }, "b", function()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        { description = "toggle wibox", group = "awesome" }),

    -- On-the-fly useless gaps change
    awful.key({ altkey, "Control" }, "=", function() backend.util.useless_gaps_resize(1) end,
        { description = "increment useless gaps", group = "tag" }),
    awful.key({ altkey, "Control" }, "-", function() backend.util.useless_gaps_resize(-1) end,
        { description = "decrement useless gaps", group = "tag" }),


    -- layout changing
    awful.key({ modkey, altkey }, "t", function() awful.layout.set(awful.layout.suit.tile) end,
        { description = "change layout to tile", group = "layout manipulation" }),
    awful.key({ modkey, altkey }, "d", function() awful.layout.set(awful.layout.suit.spiral.dwindle) end,
        { description = "change layout to dwindle", group = "layout manipulation" }),
    awful.key({ modkey, altkey }, "s", function() awful.layout.set(awful.layout.suit.spiral.name) end,
        { description = "change layout to spiral", group = "layout manipulation" }),



    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function() backend.util.add_tag() end,
        { description = "add new tag", group = "tag" }),
    awful.key({ modkey, "Shift" }, "r", function() backend.util.rename_tag() end,
        { description = "rename tag", group = "tag" }),
    awful.key({ modkey, "Shift" }, "Left", function() backend.util.move_tag(-1) end,
        { description = "move tag to the left", group = "tag" }),
    awful.key({ modkey, "Shift" }, "Right", function() backend.util.move_tag(1) end,
        { description = "move tag to the right", group = "tag" }),
    awful.key({ modkey, "Shift" }, "d", function() backend.util.delete_tag() end,
        { description = "delete tag", group = "tag" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function()
            awful.spawn.easy_async(terminal, function()

            end)
        end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, altkey }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, altkey }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, { description = "restore minimized", group = "client" }),



    -- Screen brightness
    awful.key({}, "XF86MonBrightnessUp", function()
            os.execute("xbacklight -inc 1.5")
            awesome.emit_signal("brightness_change")
        end,
        { description = "+1.5%", group = "hotkeys" }),
    awful.key({}, "XF86MonBrightnessDown", function()
            os.execute("xbacklight -dec 1.5")
            awesome.emit_signal("brightness_change")
        end,
        { description = "-1.5%", group = "hotkeys" }),

    -- Volume
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            os.execute("pamixer --allow-boost --increase 7")
            awesome.emit_signal("volume_change")
        end,
        { description = "Increase Volume by 7", group = "hotkeys" }),

    awful.key({}, "XF86AudioLowerVolume",
        function()
            os.execute("pamixer --allow-boost --decrease 7")
            awesome.emit_signal("volume_change")
        end,
        { description = "Decrease Volume by 7", group = "hotkeys" }),

    awful.key({}, "XF86AudioMute",
        function()
            os.execute("pamixer --toggle-mute")
            awesome.emit_signal("volume_change")
        end,
        { description = "Mute/Unmute the Speaker", group = "hotkeys" }),

    awful.key({}, "#198",
        function()
            os.execute("amixer set Capture toggle")
            awesome.emit_signal("volume_change")
        end,
        { description = "Mute/Unmute Microphone", group = "hotkeys" }),

    -- User programs
    awful.key({ modkey }, "q", function()
            awful.spawn.easy_async(browser, function() end)
        end,
        { description = "run browser", group = "launcher" }),
    awful.key({ modkey }, "x", function() awful.spawn.easy_async("code", function() end) end,
        { description = "run vscode", group = "launcher" }),
    awful.key({ modkey }, "e", function() awful.spawn.easy_async("thunar", function() end) end,
        { description = "run explorer", group = "launcher" }),
    awful.key({ modkey }, "d", function() awful.spawn.easy_async("discord", function() end) end,
        { description = "run discord", group = "launcher" }),
    awful.key({ modkey }, "s", function() awful.spawn.easy_async("spotify", function() end) end,
        { description = "run spotify", group = "launcher" }),
    awful.key({ modkey }, "r",
        function()
            awful.spawn.easy_async("sh /home/vix/.config/rofi/launchers/launcher.sh", function()

            end)
        end,
        { description = "run rofi desktop applications", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "s",
        function()
            awful.spawn.easy_async_with_shell("sh /home/vix/dotfiles/awesome/screenshot_selection.sh", function()

            end)
        end,
        { description = "capture selection screenshot", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "#107",
        function()
            awful.spawn.easy_async_with_shell("sh /home/vix/dotfiles/awesome/screenshot_screen.sh", function()

            end)
        end,
        { description = "capture selection screenshot", group = "launcher" })

)

clientkeys = mytable.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = mytable.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = mytable.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

local x = require("components").brightness
require("components").volume_bar({ shape = "default", colorscheme = "default" })
awful.spawn.easy_async_with_shell("picom --config ~/dotfiles/picom/picom.conf ", function()

end)
awful.spawn.easy_async_with_shell("pamixer --unmute ", function()

end)
