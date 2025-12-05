#!/bin/sh

# Define color codes
CYAN='\033[1;36m'
NC='\033[0m' # No Color
PURPLE='\033[1;35m'
RED='\033[1;31m'

# Qnnounce start, sync dots to git
#sleep 0.3
#echo -e "${PURPLE}Syncing dots to github...${NC}"
#/etc/nixos/dotfiles/scripts/nixos-git-sync.sh
#sleep 0.3
#echo -e "${PURPLE}Starting full system upgrade...${NC}"
#sleep 0.3

# Print current NixOS version
echo -e "${CYAN}Current NixOS version:${NC}"
nixos-version
sleep 0.3

# Print current running generation number
echo -e "${CYAN}Currently running NixOS generation:${NC}"
readlink /nix/var/nix/profiles/system | cut -d '-' -f 2
sleep 0.3

# Print current running generation build date
echo -e "${CYAN}...which was built at:${NC}"
stat -c '%y' /run/current-system
sleep 0.3

# Print current NixOS channel
NIXURL=$(grep 'nixpkgs.url' /etc/nixos/flake.nix | cut -d '"' -f 2)
HMURL=$(grep 'home-manager.url' /etc/nixos/flake.nix | cut -d '"' -f 2)
echo -e "${CYAN}Current NixOS channels:${NC}"
echo -e "\033[1m Nixpkgs: \033[0m      $NIXURL"
echo -e "\033[1m Home-manager: \033[0m $HMURL"
sleep 0.3

# Brace for impact
sleep 0.3
echo -e "${PURPLE}!!! SENDING IT !!! Prepare for lag; things will build after downloading...${NC}"
sleep 1

# Update Nix flake
cd /etc/nixos
echo -e "${CYAN}Updating Nix flake...${NC}"
doas nix flake update
sleep 0.3
echo -e "\e[3m~GREAT SUCCESS~\e[0m"

# Update Nix channels
#echo -e "${CYAN}Updating Nix channels...${NC}"
#doas nix-channel --update
#if [ $? -ne 0 ]; then
#    echo -e "{$RED}Error updating Nix channels.${NC}" >&2
#    exit 1
#fi
sleep 0.3

# Upgrade the system packages
echo -e "${CYAN}Upgrading system packages...${NC}"
doas nixos-rebuild switch --upgrade
if [ $? -ne 0 ]; then
    echo -e "${RED}Error upgrading system packages.${NC}" >&2
    exit 1
fi

# Print number of NixOS generations before garbage collection
echo -e "${CYAN}NixOS generation count:${NC}"
doas nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l

# Perform garbage collection to delete old generations
#echo -e "${CYAN}Deleting generations older than 30d, keeping 10 minimum...${NC}"
#for gen in $to_delete; do
#    doas nix-env --delete-generation 14d +10 > /dev/null 2>&1
#done

# Garbage collection
#echo -e "${CYAN}Collecting and deleting garbage...${NC}"
#doas nix-store --gc > /dev/null 2>&1

# Print number of NixOS generations after garbage collection
#echo -e "${CYAN}NixOS generations after garbage collection:${NC}"
#doas nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l

# Print disk space usage in a human-readable format, excluding tmpfs
echo -e "${CYAN}Disk usage summary:${NC}"
df -h | grep -v 'tmpfs' | grep -v 'efi'

echo -e "${PURPLE}Full system upgrade complete.${NC}"
