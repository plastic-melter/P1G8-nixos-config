#!/usr/bin/env bash

if eww active-windows | grep -q "stats"; then
  eww close stats
else
  eww open stats
fi
