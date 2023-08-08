#!/usr/bin/env bash
fg='222222FF' 
bg='222222FF'
leaf='948946FF'
i3lock \
    --color=FFFFFFFF \
    --screen 1		\
    --inside-color=$fg \
    --insidever-color=$fg \
    --insidewrong-color=$fg \
    --ring-color=$fg \
    --ringver-color=FABD2FFF \
    --ringwrong-color=FB4934FF \
    --separator-color=$fg \
    --line-color=$bg \
    --keyhl-color=$bg \
    --bshl-color=FB4934FF \
    --ring-width=6 \
    --radius=32 \
    --time-color=$fg \
    --time-str='%H:%M' \
    --time-font='Fira Code, Medium' \
    --time-align=2 \
    --time-size=18 \
    --time-pos="954:35" \
    --ind-pos="941:1028"    \
    --date-color=$fg \
    --date-str='%d|%m|%y' \
    --date-font='Iosevka Semibold' \
    --date-align=1 \
    --date-size=96 \
    --date-pos="736:450" \
    --wrong-color=$leaf \
    --verif-color=$leaf \
    --modif-color=$leaf \
    --layout-color=$leaf \
    --greeter-color=$leaf \
    --verif-font='Symbols Nerd Font Mono' \
    --wrong-font='Symbols Nerd Font Mono' \
    --greeter-font='Symbols Nerd Font Mono' \
    --greeter-pos="934:640"    \
    --verif-text='󰞦' \
    --wrong-text='󰞦' \
    --lockfailed-text='󰞦' \
    --greeter-text='󰞦' \
    --verif-size=96 \
    --wrong-size=96 \
    --greeter-size=96 \
    --ignore-empty-password \
    --pass-media-keys \
    --pass-screen-keys \
    --indicator \
    --clock \
    --no-verify
