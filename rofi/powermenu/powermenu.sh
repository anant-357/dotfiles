#!/usr/bin/env bash
# Current Theme
dir="$HOME/.config/rofi/powermenu/"
theme='powermenu-monochrome'

# CMDs
lastlogin="`last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7`"
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Colors
color_lock='#ff0000'
color_suspend='#00ff00'
color_logout='#0000ff'
color_hibernate='#ffff00'
color_reboot='#ff00ff'
color_shutdown='#00ffff'

# Options
hibernate=''
shutdown=''
reboot=''
lock=''
suspend=''
logout='󰍂'
yes=''
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p " $USER@$host" \
		-mesg " Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi 
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			sudo /usr/bin/shutdown -a now
		elif [[ $1 == '--reboot' ]]; then
			sudo /usr/bin/shutdown -r now
		elif [[ $1 == '--hibernate' ]]; then
			sudo systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			sudo systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			pkill awesome
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $hibernate)
		run_cmd --hibernate
        ;;
    $lock)
		betterlockscreen_rapid 20 1
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
