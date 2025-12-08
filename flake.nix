{
  description = "Flakey at best";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.url = "github:hyprwm/Hyprland/v0.52.1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ...}@inputs: {
    nixosConfigurations = {
      P1G8 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
	  hyprland.nixosModules.default
	  { programs.hyprland.enable = true; }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
	      useGlobalPkgs = true;
              useUserPackages = true;
              users.joe = import ./home.nix;
	      extraSpecialArgs = { inherit inputs; };
	    };
          }
        ];
      };
    };
  };
}
