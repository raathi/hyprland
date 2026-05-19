#!/bin/bash

set -u -o pipefail

refresh_waybar() {
    local pid_output
    local -a pids=()

    if ! pid_output=$(pidof waybar 2>/dev/null); then
        return 0
    fi

    read -r -a pids <<<"$pid_output"
    ((${#pids[@]} > 0)) || return 0

    kill -SIGRTMIN+8 "${pids[@]}" 2>/dev/null || true
}

print_profile() {
    local profile

    if command -v asusctl >/dev/null 2>&1 && profile=$(asusctl profile -p 2>/dev/null); then
        printf '%s\n' "${profile#Active profile is }"
        return 0
    fi

    if command -v powerprofilesctl >/dev/null 2>&1 && profile=$(powerprofilesctl get 2>/dev/null); then
        printf '%s\n' "$profile"
        return 0
    fi

    return 1
}

cycle_profile() {
    local current_profile
    local next_profile

    if command -v asusctl >/dev/null 2>&1 && asusctl profile -n >/dev/null 2>&1; then
        refresh_waybar
        return 0
    fi

    if ! command -v powerprofilesctl >/dev/null 2>&1; then
        printf 'No supported power profile backend found.\n' >&2
        return 1
    fi

    if ! current_profile=$(powerprofilesctl get 2>/dev/null); then
        printf 'Unable to read the current power profile.\n' >&2
        return 1
    fi

    case "$current_profile" in
        power-saver) next_profile="balanced" ;;
        balanced) next_profile="performance" ;;
        performance) next_profile="power-saver" ;;
        *) next_profile="balanced" ;;
    esac

    powerprofilesctl set "$next_profile" || return 1
    refresh_waybar
}

case "${1:-status}" in
    status)
        print_profile
        ;;
    cycle)
        cycle_profile
        ;;
    *)
        printf 'Usage: %s [status|cycle]\n' "$0" >&2
        exit 1
        ;;
esac
