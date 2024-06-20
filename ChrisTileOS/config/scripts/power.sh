#!/bin/bash

active_sounds=yes
sounds_dir="$HOME/.config/sounds/"

chosen=$(printf " Lock\n󰍃 Logout\n󰜉 Reboot\n⏻ PowerOff\n" | rofi -p "Power" -dmenu -i -theme-str)

case "$chosen" in
    " Lock")
        yes_no=$(printf " no\n yes" | rofi -p "Would You Like to $chosen" -dmenu -i -theme-str)
        case $yes_no in
            [no]* ) exit;;
            [yes]* )
                if [[ "$active_sounds" = yes ]]; then
                    mpv --no-video "${sounds_dir}game-bonus-144751.mp3" && xscreensaver-command -lock
                else
                    xscreensaver-command -lock
                fi
                ;;
        esac
        ;;
    "󰍃 Logout")
        yes_no=$(printf " no\n yes" | rofi -p "Would You Like to $chosen" -dmenu -i -theme-str)
        case $yes_no in
            [no]* ) exit;;
            [yes]* )
                if [[ "$active_sounds" = yes ]]; then
                    mpv --no-video "${sounds_dir}cute-level-up-3-189853.mp3" && qtile cmd-obj -o cmd -f shutdown
                else
                    qtile cmd-obj -o cmd -f shutdown
                fi
                ;;
        esac
        ;;
    "󰜉 Reboot")
        yes_no=$(printf " no\n yes" | rofi -p "Would You Like to $chosen" -dmenu -i -theme-str)
        case $yes_no in
            [no]* ) exit;;
            [yes]* )
                if [[ "$active_sounds" = yes ]]; then
                    mpv --no-video "${sounds_dir}ambient-piano-logo-165357.mp3" && reboot
                else
                    reboot
                fi
                ;;
        esac
        ;;
    "⏻ PowerOff")
        yes_no=$(printf " no\n yes" | rofi -p "Would You Like to $chosen" -dmenu -i -theme-str)
        case $yes_no in
            [no]* ) exit;;
            [yes]* )
                if [[ "$active_sounds" = yes ]]; then
                    mpv --no-video "${sounds_dir}lovelyboot1-103697.mp3" && poweroff
                else
                    poweroff
                fi
                ;;
        esac
        ;;
esac
