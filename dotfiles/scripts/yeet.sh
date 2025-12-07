#!/bin/sh
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

# Add untracked files BEFORE building
echo -e "${CYAN}Staging new files...${NC}"
git -C /etc/nixos add -A

echo -e "${CYAN}Rebuilding NixOS system...${NC}"

# Capture output and check for success
BUILD_OUTPUT=$(doas nixos-rebuild switch --flake /etc/nixos 2>&1 | tee /dev/tty)

# Check for both successful activation AND no failed units
if echo "$BUILD_OUTPUT" | grep -q "activating the configuration" && \
   ! echo "$BUILD_OUTPUT" | grep -q "the following units failed"; then
    echo -e "${GREEN}Rebuild succeeded${NC}"
    
    # Only commit/push if online
    if ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
        git -C /etc/nixos commit -m "auto-commit: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true
        git -C /etc/nixos push 2>/dev/null || true
        echo -e "${GREEN}Push complete${NC}"
    else
        echo -e "${PURPLE}Offline - skipping git push${NC}"
    fi
else
    echo -e "${RED}Rebuild failed - skipping git operations${NC}"
    exit 1
fi
