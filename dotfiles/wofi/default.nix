{ pkgs, lib, config, ...}:

with lib; let
  wofi_config = import ./config.nix {inherit osConfig config lib pkgs;};
  wofi_style = import ./style.nix {inherit (config) colorscheme;};
in {
  programs.wofi = {
    enable = true;
    package = pkgs.wofi;
    settings = wofi_config;
    style = wofi_style;
  };
}
