#!/usr/bin/env zsh

# List of allowed brightness steps
STEPS=(0 1 2 3 4 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100)

get_current_pct() {
    brightnessctl -m | awk -F, '{gsub(/[%]/,"",$4); print $4}'
}

find_next() {
    local cur=$1 dir=$2
    if [[ $dir == up ]]; then
        for s in $STEPS; do
            if (( s > cur )); then
                print $s
                return
            fi
        done
        print $cur
    else
        local last=$cur
        for s in $STEPS; do
            if (( s >= cur )); then
                print $last
                return
            fi
            last=$s
        done
        print $last
    fi
}

case "$1" in
    up)
        cur=$(get_current_pct)
        nxt=$(find_next $cur up)
        brightnessctl set "${nxt}%"
        ;;
    down)
        cur=$(get_current_pct)
        nxt=$(find_next $cur down)
        brightnessctl set "${nxt}%"
        ;;
    set)
        brightnessctl set "$2%"
        ;;
    *)
        print "Usage: $0 {up|down|set <percent>}"
        exit 1
        ;;
esac

