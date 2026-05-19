#!/bin/bash

set -eu

choice=$(
    printf '%s\n' \
        'Lock' \
        'Logout' \
        'Suspend' \
        'Reboot' \
        'Shutdown' \
    | fuzzel --dmenu --prompt 'Power' --lines 5
)

case "$choice" in
    Lock)
        exec hyprlock
        ;;
    Logout)
        exec hyprshutdown
        ;;
    Suspend)
        loginctl lock-session
        exec systemctl suspend
        ;;
    Reboot)
        exec systemctl reboot
        ;;
    Shutdown)
        exec systemctl poweroff
        ;;
    '')
        exit 0
        ;;
    *)
        printf 'Unknown power action: %s\n' "$choice" >&2
        exit 1
        ;;
esac
