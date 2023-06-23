local dpi                   = require("beautiful.xresources").apply_dpi
local os                    = os

local theme                 = {}
theme.dir                   = os.getenv("HOME") .. "/.config/awesome/"
theme.wallpaper             = theme.dir .. "/wallpapers/gruvbox/deer.jpg"
theme.colors                = require('colorschemes.gruvbox')

theme.font                  = "Fira Code, Medium 11"
theme.fg_normal             = "#ebdbb2"
theme.fg_focus              = "#fabd2f"
theme.fg_urgent             = "#fb4934"
theme.bg_normal             = "#282828"
theme.bg_focus              = "#1d2021"
theme.bg_urgent             = "#1A1A1A"
theme.border_width          = dpi(3)
theme.border_normal         = theme.colors.dark_gray
theme.border_focus          = theme.colors.light_gray
-- theme.border_marked = "#CC9393"
theme.useless_gap           = dpi(15)
theme.layout_tile           = "󰢡"
theme.tasklist_disable_icon = true

-- Colors
theme.background            = "#282828"
theme.background_alt        = "#1d2021"
theme.foreground            = "#ebdbb2"
theme.primary               = theme.colors.light_orange
theme.secondary             = theme.colors.light_yellow
theme.alert                 = theme.colors.light_red
theme.disabled              = theme.colors.light_gray


theme.notification_bg = "#282828"
theme.notification_fg = "#ebdbb2"
theme.tooltip_bg      = "#282828"
theme.tooltip_fg      = "#ebdbb2"
theme.border_normal   = "#3F3F3F"
theme.border_focus    = "#7F7F7F"
theme.border_marked   = "#CC9393"


return theme
