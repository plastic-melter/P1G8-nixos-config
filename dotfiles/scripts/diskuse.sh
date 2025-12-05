#!/bin/sh
Main=$(df -h | grep cryptroot | awk '{print $5}')
Alt=$(df -h | grep pool | awk '{print $5}')
Gaming=$(df -h | grep Storage | awk '{print $5}')
echo -n "${Main} | ${Alt} | ${Gaming}"
