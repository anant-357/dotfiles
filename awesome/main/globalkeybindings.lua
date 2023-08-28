local gears = require("gears")
local awful = require("awful")
local backend = require("backend")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility
local shell = require("awful.util").shell
local beautiful = require("beautiful")

local modkey = "Mod4"
local altkey = "Mod1"
local terminal = "wezterm"
local cycle_prev = true
local browser = "firefox"
local user = os.getenv("USER")
local helpers = require("backend.helpers")

local function toggle_statusbars()
    for s in screen do
        s.displaybar.visible = not s.displaybar.visible
        if s.statusbar then
            s.statusbar.visible = not s.statusbar.visible
        end

        if not s.displaybar.visible then
            s.padding = {
                top = 0,
                bottom = 0,
                left = 0,
                right = 0
            }
        else
            s.padding = {
                top = -15,
                bottom = 75,
                left = 0,
                right = 0
            }
        end

    end
end

globalkeys = mytable.join( -- X screen locker
awful.key({modkey}, "l", function()
    awful.spawn("sh /home/" .. user .. "/.config/awesome/lock.sh")
end, {
    description = "lock screen",
    group = "hotkeys"
}), awful.key({modkey, "Shift"}, "l", function()
    awful.spawn.easy_async("eww open powermenu", function()
    end)
end, {
    description = "exit menu",
    group = "hotkeys"
}), awful.key({modkey, "Shift"}, "x", function()
    os.execute("eww open dashboard")
end, {
    description = "exit menu",
    group = "hotkeys"
}), -- Tag browsing
awful.key({modkey}, "Left", awful.tag.viewprev, {
    description = "view previous",
    group = "tag"
}), awful.key({modkey}, "Right", awful.tag.viewnext, {
    description = "view next",
    group = "tag"
}), awful.key({modkey}, "Escape", awful.tag.history.restore, {
    description = "go back",
    group = "tag"
}), -- Default client focus
awful.key({altkey}, "j", function()
    awful.client.focus.byidx(1)
end, {
    description = "focus next by index",
    group = "client"
}), awful.key({altkey}, "k", function()
    awful.client.focus.byidx(-1)
end, {
    description = "focus previous by index",
    group = "client"
}), -- By-direction client focus
awful.key({modkey}, "j", function()
    awful.client.focus.global_bydirection("down")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "focus down",
    group = "client"
}), awful.key({modkey}, "k", function()
    awful.client.focus.global_bydirection("up")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "focus up",
    group = "client"
}), awful.key({modkey}, "h", function()
    awful.client.focus.global_bydirection("left")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "focus left",
    group = "client"
}), awful.key({modkey}, "l", function()
    awful.client.focus.global_bydirection("right")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "focus right",
    group = "client"
}), -- Layout manipulation
awful.key({modkey, "Shift"}, "j", function()
    awful.client.swap.byidx(1)
end, {
    description = "swap with next client by index",
    group = "client"
}), awful.key({modkey, "Shift"}, "k", function()
    awful.client.swap.byidx(-1)
end, {
    description = "swap with previous client by index",
    group = "client"
}), awful.key({modkey, "Control"}, "j", function()
    awful.screen.focus_relative(1)
end, {
    description = "focus the next screen",
    group = "screen"
}), awful.key({modkey, "Control"}, "k", function()
    awful.screen.focus_relative(-1)
end, {
    description = "focus the previous screen",
    group = "screen"
}), awful.key({modkey}, "u", awful.client.urgent.jumpto, {
    description = "jump to urgent client",
    group = "client"
}), awful.key({modkey}, "Tab", function()
    if cycle_prev then
        awful.client.focus.history.previous()
    else
        awful.client.focus.byidx(-1)
    end
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "cycle with previous/go back",
    group = "client"
}), -- On-the-fly useless gaps change
awful.key({altkey, "Control"}, "=", function()
    backend.util.useless_gaps_resize(1)
end, {
    description = "increment useless gaps",
    group = "tag"
}), awful.key({altkey, "Control"}, "-", function()
    backend.util.useless_gaps_resize(-1)
end, {
    description = "decrement useless gaps",
    group = "tag"
}), -- layout changing
awful.key({modkey, altkey}, "t", function()
    awful.layout.set(awful.layout.suit.tile)
end, {
    description = "change layout to tile",
    group = "layout manipulation"
}), awful.key({modkey, altkey}, "f", function()
    awful.layout.set(awful.layout.suit.floating)
end, {
    description = "change layout to dwindle",
    group = "layout manipulation"
}), -- Dynamic tagging
awful.key({modkey, "Shift"}, "n", function()
    backend.util.add_tag()
end, {
    description = "add new tag",
    group = "tag"
}), awful.key({modkey, "Shift"}, "r", function()
    backend.util.rename_tag()
end, {
    description = "rename tag",
    group = "tag"
}), awful.key({modkey, "Shift"}, "Left", function()
    backend.util.move_tag(-1)
end, {
    description = "move tag to the left",
    group = "tag"
}), awful.key({modkey, "Shift"}, "Right", function()
    backend.util.move_tag(1)
end, {
    description = "move tag to the right",
    group = "tag"
}), awful.key({modkey, "Shift"}, "d", function()
    backend.util.delete_tag()
end, {
    description = "delete tag",
    group = "tag"
}), -- Standard program
awful.key({modkey}, "Return", function()
    awful.spawn.easy_async(terminal, function()

    end)
end, {
    description = "open a terminal",
    group = "launcher"
}), awful.key({modkey, "Control"}, "r", awesome.restart, {
    description = "reload awesome",
    group = "awesome"
}), awful.key({modkey, "Shift"}, "q", awesome.quit, {
    description = "quit awesome",
    group = "awesome"
}), awful.key({modkey, altkey}, "l", function()
    awful.tag.incmwfact(0.01)
end, {
    description = "increase master width factor",
    group = "layout"
}), awful.key({modkey, altkey}, "h", function()
    awful.tag.incmwfact(-0.01)
end, {
    description = "decrease master width factor",
    group = "layout"
}), awful.key({modkey, altkey}, "j", function()
    awful.tag.incmhfact(0.01)
end, {
    description = "increase master width factor",
    group = "layout"
}), awful.key({modkey, altkey}, "k", function()
    awful.tag.incmhfact(-0.01)
end, {
    description = "decrease master width factor",
    group = "layout"
}), awful.key({modkey, "Shift"}, "h", function()
    awful.tag.incnmaster(1, nil, true)
end, {
    description = "increase the number of master clients",
    group = "layout"
}), awful.key({modkey, "Shift"}, "l", function()
    awful.tag.incnmaster(-1, nil, true)
end, {
    description = "decrease the number of master clients",
    group = "layout"
}), awful.key({modkey, "Control"}, "h", function()
    awful.tag.incncol(1, nil, true)
end, {
    description = "increase the number of columns",
    group = "layout"
}), awful.key({modkey, "Control"}, "l", function()
    awful.tag.incncol(-1, nil, true)
end, {
    description = "decrease the number of columns",
    group = "layout"
}), awful.key({modkey}, "space", function()
    awful.layout.inc(1)
end, {
    description = "select next",
    group = "layout"
}), awful.key({modkey, "Shift"}, "space", function()
    awful.layout.inc(-1)
end, {
    description = "select previous",
    group = "layout"
}), awful.key({modkey, "Control"}, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
        c:emit_signal("request::activate", "key.unminimize", {
            raise = true
        })
    end
end, {
    description = "restore minimized",
    group = "client"
}), -- Screen brightness
awful.key({}, "XF86MonBrightnessUp", function()
    os.execute("sudo xbacklight -inc 1.5")
    awesome.emit_signal("brightness_change")
end, {
    description = "+1.5%",
    group = "hotkeys"
}), awful.key({}, "XF86MonBrightnessDown", function()
    os.execute("sudo xbacklight -dec 1.5")
    awesome.emit_signal("brightness_change")
end, {
    description = "-1.5%",
    group = "hotkeys"
}), -- Volume
awful.key({}, "XF86AudioRaiseVolume", function()
    os.execute("pamixer --allow-boost --increase 7")
    awesome.emit_signal("volume_change")
end, {
    description = "Increase Volume by 7",
    group = "hotkeys"
}), awful.key({}, "XF86AudioLowerVolume", function()
    os.execute("pamixer --allow-boost --decrease 7")
    awesome.emit_signal("volume_change")
end, {
    description = "Decrease Volume by 7",
    group = "hotkeys"
}), awful.key({}, "XF86AudioMute", function()
    os.execute("pamixer --toggle-mute")
    awesome.emit_signal("volume_change")
end, {
    description = "Mute/Unmute the Speaker",
    group = "hotkeys"
}), awful.key({}, "#198", function()
    os.execute("amixer set Capture toggle")
    awesome.emit_signal("volume_change")
end, {
    description = "Mute/Unmute Microphone",
    group = "hotkeys"
}), -- User programs
awful.key({modkey}, "q", function()
    awful.spawn.easy_async(browser, function()
    end)
end, {
    description = "run browser",
    group = "launcher"
}), awful.key({modkey}, "x", function()
    awful.spawn.easy_async("code", function()
    end)
end, {
    description = "run vscode",
    group = "launcher"
}), awful.key({modkey}, "e", function()
    awful.spawn.easy_async("nautilus", function()
    end)
end, {
    description = "run explorer",
    group = "launcher"
}), awful.key({modkey}, "d", function()
    awful.spawn.easy_async("discord", function()
    end)
end, {
    description = "run discord",
    group = "launcher"
}), awful.key({modkey}, "s", function()
    awful.spawn.easy_async("spotify", function()
    end)
end, {
    description = "run spotify",
    group = "launcher"
}), awful.key({modkey}, "r", function()
    awful.spawn.easy_async("sh /home/" .. user .. "/.config/rofi/launchers/launcher.sh", function()

    end)
end, {
    description = "run rofi desktop applications",
    group = "launcher"
}), awful.key({modkey, "Shift"}, "s", function()
    awful.spawn.easy_async_with_shell("eww open screenshotmenu", function()

    end)
end, {
    description = "capture selection screenshot",
    group = "launcher"
}), awful.key({modkey, "Shift"}, "b", function()
    awesome.emit_signal("toggle_wibar")
end, {
    description = "toggle wibox",
    group = "awesome"
}))

for i = 1, 9 do
    globalkeys = mytable.join(globalkeys, -- View tag only.
    awful.key({modkey}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end, {
        description = "view tag #" .. i,
        group = "tag"
    }), -- Toggle tag display.
    awful.key({modkey, "Control"}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end, {
        description = "toggle tag #" .. i,
        group = "tag"
    }), -- Move client to tag.
    awful.key({modkey, "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end, {
        description = "move focused client to tag #" .. i,
        group = "tag"
    }), -- Toggle tag on focused client.
    awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end, {
        description = "toggle focused client on tag #" .. i,
        group = "tag"
    }))
end

root.keys(globalkeys)
