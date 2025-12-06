#!/bin/sh
echo -e "${CYAN}Staging all /etc/nixos changes...${NC}"
git -C /etc/nixos add -A
git -C /etc/nixos commit -m "auto-commit: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true
echo -e "${CYAN}Rebuilding NixOS system...${NC}"
doas nixos-rebuild switch --flake /etc/nixos
