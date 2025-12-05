#!/usr/bin/env bash
export WINEPREFIX="$HOME/Storage/wine/plutonium"

# Optional: set a specific wine if not in PATH
# export PATH="/run/current-system/sw/bin:$PATH"

exec wine "$HOME/Storage/wine/plutonium/drive_c/users/joe/AppData/Local/Plutonium/bin/plutonium-launcher-win32.exe"
