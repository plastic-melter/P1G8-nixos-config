#!/bin/sh
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${CYAN}Rebuilding NixOS system...${NC}"
if doas nixos-rebuild switch --flake /etc/nixos 2>&1 | grep -v "warning: Git tree.*is dirty"; then
    REBUILD_SUCCESS=$?
else
    REBUILD_SUCCESS=$?
fi

if [ $REBUILD_SUCCESS -eq 0 ]; then
    echo -e "${GREEN}Rebuild succeeded${NC}"
    
    echo -e "${CYAN}Staging all /etc/nixos changes...${NC}"
    git -C /etc/nixos add -A
    
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
