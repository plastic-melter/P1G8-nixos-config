#!/usr/bin/env bash
# power.sh — print CPU and GPU power draw (W)

    cpu_w=$(doas bash -c 'E1=$(cat /sys/class/powercap/intel-rapl:0/energy_uj); sleep 1; E2=$(cat /sys/class/powercap/intel-rapl:0/energy_uj); echo "scale=2; ($E2 - $E1) / 1000000" | bc')
    gpu_w=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits 2>/dev/null)
    echo "${cpu_w}W + ${gpu_w}W"

