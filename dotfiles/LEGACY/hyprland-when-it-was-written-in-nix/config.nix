{
wayland.windowManager.hyprland = {
  xwayland.enable = true;
  #package = 
  #plugins = [ ];
};

wayland.windowManager.hyprland.settings = {
  # Basic config
  input = {
    kb_layout = "jp"; 
    touchpad.natural_scroll = "yes";
    sensitivity = 0;
  };
  general = {
    gaps_in = 5;
    gaps_out = 5;
    border_size = 5;
    #"col.active_border" = "rgba(00E5FFFF) rgba(DB00FFFF) 45deg";
    "col.active_border" = "rgba(DB00FFFF) rgba(00E5FFFF) 90deg";
    "col.inactive_border" = "rgba(595959aa)";
    layout = "dwindle";
  };
  decoration = {
    rounding = 4;
    #blur = "yes";
    #blur_size = 3;
    #blur_passes = 1;
    #blur_new_optimizations = "on";
    drop_shadow = "yes";
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
    active_opacity = "1.0";
    inactive_opacity = "0.85";
  };
  animations = {
    enabled = "yes";
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
  
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };
  dwindle = {
    pseudotile = "yes";
    preserve_split = "yes";
  };
  master = {
    new_is_master = true;
  };
  # Touchpad gestures
  gestures = {
    workspace_swipe = "on";
    workspace_swipe_fingers = "3";
    workspace_swipe_distance = "500";
    workspace_swipe_cancel_ratio = "0.15";
  };
  # Window rules
    windowrule = [
      "float,^(imv)$"
      "float,^(thunar)$"
      "float,^(lutris)$"
      "float,^(Pavucontrol)$"
      "float,^(vlc)$"
      "float,^(kcolorchooser)$"
      "float,^(steam)$"
      "float,^(blueman-manager)$"
      "float,^(dolphin-emu)$"
    ];
  # Setup stuff
    #monitor = "eDP-1,2560x1600@60,0x0,1";
    monitor = ",preferred,auto,1";
    "$mod" = "SUPER";
    "env" = "XCURSOR_SIZE,16";
  bind = [
  # App launching
    "$mod, Return, exec, foot"
    "$mod, Z, exec, wofi --show drun"
    "$mod SHIFT, Z, exec, nwggrid -s 128 -n 9"
    "$mod SHIFT, L, exec, swaylock"
    "$mod SHIFT, C, exec, kcolorchooser"
    "$mod, P, exec, LANG=en_US.utf8 prusa-slicer"
  # Commands
    "$mod SHIFT, Q, killactive"
    "$mod SHIFT, E, exit"
    "$mod SHIFT, Space, togglefloating"
    "$mod, Space, pseudo"
    "$mod, C, centerwindow"
  # Function keys
    ", Print, exec, /etc/nixos/dotfiles/hyprland/screenie.sh"
  # WM: switch workspaces
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
  # WM: change focus
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"
  # WM: send to workspace
    "$mod SHIFT, 1, movetoworkspacesilent, 1"
    "$mod SHIFT, 2, movetoworkspacesilent, 2"
    "$mod SHIFT, 3, movetoworkspacesilent, 3"
    "$mod SHIFT, 4, movetoworkspacesilent, 4"
    "$mod SHIFT, 5, movetoworkspacesilent, 5"
  # WM: scroll workspaces
    "$mod, mouse_down, workspace, e-1"
    "$mod, mouse_up, workspace, e+1"
  # WM: toggle fullscreen
    "$mod, f, fullscreen," 
  # WM: swap windows
    "$mod SHIFT, up, swapwindow, u"
    "$mod SHIFT, down, swapwindow, d"
    "$mod SHIFT, left, swapwindow, l"
    "$mod SHIFT, right, swapwindow, r"
  # WM: move windows (floating)
    "$mod SHIFT, up, moveactive, 0 -100"
    "$mod SHIFT, down, moveactive, 0 100"
    "$mod SHIFT, left, moveactive, -100 0"
    "$mod SHIFT, right, moveactive, 100 0"
  # wallpapers
    
  ];
  bindm = [
  # WM: move/resize with mouse
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
  binde = [
    "$mod CONTROL, up, resizeactive, 0 -48"
    "$mod CONTROL, down, resizeactive, 0 48"
    "$mod CONTROL, left, resizeactive, -48 0"
    "$mod CONTROL, right, resizeactive, 48 0"
    ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ", XF86AudioRaiseVolume, exec, pamixer -i 5"
    ", XF86AudioLowerVolume, exec, pamixer -d 5"
  ];
  bindl = [
    ",switch:[Lid Switch],exec,swaylock" 
  ];
  # Startup programs
  "exec-once" = [
    "swaybg -i /etc/nixos/dotfiles/wallpapers/simple1.jpg -m fill"
    "waybar"
    "dunst"
  ];
};

}
