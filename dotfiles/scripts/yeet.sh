#!/bin/sh
echo -e "${CYAN}Staging all /etc/nixos changes...${NC}"
git -C /etc/nixos add -A

# Only commit/push if online
if ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
    git -C /etc/nixos commit -m "auto-commit: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true
    git -C /etc/nixos push 2>/dev/null || true
else
    echo -e "${PURPLE}Offline - skipping git push${NC}"
fi

echo -e "${CYAN}Rebuilding NixOS system...${NC}"
doas nixos-rebuild switch --flake /etc/nixos
