#!/bin/sh
#W=$(cat /sys/class/power_supply/BAT0/power_now)
#W=$(echo $W1)
S=$(cat /sys/class/power_supply/BAT0/status)

#if test $W -lt 999999
#then
#  echo -n "  0W"
#  S=Idle
#else
#  printf -v W1 "%.1f" "${W::-6}.${W: -6:3}"
#  case $S in
#  Idle)
#    echo " Idle"
#    ;;
#  Unknown)
#    echo " ERROR"
#    ;;
#  Charging)
#    echo -n " +AC"
#    ;;
#  Discharging)
#    echo -n " -BAT"
#    ;;
#  *)
    echo " $S"
#    ;;
#  esac
#fi
