{

  description = "NeoReaper NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      spicetify-nix,
      jovian-nixos,
      nix-flatpak,
      affinity-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      unstable-overlay = final: _prev: {
        unstable = import nixpkgs-unstable {
          inherit (final) system config;
        };
      };
    in
    {
      nixosConfigurations.NeoReaper = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [ unstable-overlay ];
            nixpkgs.config.allowUnfree = true;
          }
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.xardec = {
              imports = [
                ./home.nix
                nix-flatpak.homeManagerModules.nix-flatpak
                spicetify-nix.homeManagerModules.default
              ];
              _module.args = {
                inherit spicetify-nix affinity-nix;
              };
            };
          }
        ];
      };

      homeConfigurations."xardec" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-stable.legacyPackages.${system};
        extraSpecialArgs = {
          inherit spicetify-nix affinity-nix;
        };
        modules = [
          {
            nixpkgs.overlays = [ unstable-overlay ];
            nixpkgs.config.allowUnfree = true;
          }
          ./home.nix
          nix-flatpak.homeManagerModules.nix-flatpak
          spicetify-nix.homeManagerModules.default
        ];
      };
    };
}
