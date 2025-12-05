{ inputs', lib, pkgs, ...}: {

  imports = [./config.nix];

  home.packages = with pkgs; [
#    self.packages.xwaylandvideobridge
     hyprpicker
  ];

  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  wayland.windowManager.hyprland = { 
    enable = true;
    xwayland.enable = true;
  };

}
