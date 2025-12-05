{ pkgs, lib, config, osConfig, inputs, ...}:

with lib; let
  PROGRAM_config = import ./config.nix {inherit osConfig config lib pkgs;};
in {
#  home.packages = with pkgs; [
#    examplePackage
#  ];
  programs.PROGRAM = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    package = pkgs.PROGRAM;
    settings = PROGRAM_config;
  };
}
