#!/bin/sh
eww close screenshotmenu
maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png