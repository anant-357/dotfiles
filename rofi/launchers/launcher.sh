#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/"
theme='launcher-monochrome'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
