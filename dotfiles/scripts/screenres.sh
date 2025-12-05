#!/bin/sh

# The laptop's display is always eDP-1
laptop_display="eDP-1"

# Define target resolutions
laptop_resolution_full="2560x1600"
laptop_resolution_1080="1920x1080"
laptop_resolution_touhou="1680x1050"
laptop_resolution_mid="1280x800"
laptop_resolution_VGA="640x480"

# Get the current resolution of the laptop display
current_resolution=$(hyprctl monitors | grep -A 1 "$laptop_display" | tail -n 1 | cut -d '@' -f 1 | xargs)

# Function to set resolution
set_resolution() {
    resolution=$1
    # Set resolution for the laptop display
    hyprctl keyword monitor "$laptop_display,$resolution,0x0,1"
    # Send notification with the new resolution
    notify-send "Screen Resolution" "Resolution set to $resolution"
}

# Toggle between different resolutions based on current laptop resolution
case "$current_resolution" in
    "$laptop_resolution_full")
        set_resolution "$laptop_resolution_1080"
        ;;
    "$laptop_resolution_1080")
        set_resolution "$laptop_resolution_touhou"
        ;;
    "$laptop_resolution_touhou")
        set_resolution "$laptop_resolution_mid"
        ;;
    "$laptop_resolution_mid")
        set_resolution "$laptop_resolution_VGA"
        ;;
    "$laptop_resolution_VGA")
        set_resolution "$laptop_resolution_full"
        ;;
    *)
        # Default to high resolution if none match
        set_resolution "$laptop_resolution_full"
        ;;
esac

