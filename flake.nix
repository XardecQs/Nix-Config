{
  description = "NeoReaper NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      zen-browser,
      spicetify-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      unstable-overlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${system};
      };
    in
    {
      nixosConfigurations.NeoReaper = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        modules = [
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [ unstable-overlay ];
              nixpkgs.config.allowUnfree = true;
            }
          )
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.xardec = {
              imports = [
                ./home.nix
                spicetify-nix.homeManagerModules.default
              ];
              _module.args = {
                zen-browser = zen-browser;
                spicetify-nix = spicetify-nix;
              };
            };
          }
        ];
      };

      homeConfigurations."xardec" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-stable.legacyPackages.${system};
        extraSpecialArgs = {
          zen-browser = zen-browser;
          spicetify-nix = spicetify-nix;
        };
        modules = [
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [ unstable-overlay ];
              nixpkgs.config.allowUnfree = true;
            }
          )
          ./home.nix
          spicetify-nix.homeManagerModules.default
        ];
      };
    };
}
