{
  description = "NeoReaper NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      spicetify-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.NeoReaper = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
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
                dotfilesDir = "/etc/nixos/modules/users/xardec/dotfiles";
                zen-browser = zen-browser;
                spicetify-nix = spicetify-nix;
              };
            };
          }
        ];
      };

      homeConfigurations."xardec" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          spicetify-nix.homeManagerModules.default
          {
            _module.args = {
              dotfilesDir = "/etc/nixos/modules/users/xardec/dotfiles";
              zen-browser = zen-browser;
              spicetify-nix = spicetify-nix;
            };
          }
        ];
      };
    };
}
