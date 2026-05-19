#!/bin/bash

set -eu

choice=$(
    cliphist list | fuzzel --dmenu --prompt 'Clipboard' --lines 15
)

if [[ -z "$choice" ]]; then
    exit 0
fi

cliphist decode <<<"$choice" | wl-copy
