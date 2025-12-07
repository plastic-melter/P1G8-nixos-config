{ pkgs, lib, config, osConfig, inputs, ...}:

with lib; let
  waybar_config = import ./config.nix {inherit osConfig config lib pkgs;};
  waybar_style = import ./style.nix {inherit (config) colorscheme;};
in {
  programs.waybar = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    #package = pkgs.waybar.overrideAttrs (oldAttrs: {
    #  mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #});
    #package = pkgs.waybar;
    settings = waybar_config;
    style = waybar_style;
  };
}
