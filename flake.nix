{
  description = "Flake principal de NeoReaper";

  #/--------------------/ Inputs (dependencias) /--------------------/#
  inputs = {
    # Canales principales de Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Módulos extras
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  #/--------------------/ Outputs (configuraciones generadas) /--------------------/#
  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      nix-flatpak,
      spicetify-nix,
      affinity-nix,
      ...
    }@inputs:

    let
      system = "x86_64-linux";
      # Paquetes inestables
      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config = final.config;
        };
      };
      # NixPKGs
      basePkgsConfig = {
        overlays = [ unstableOverlay ];
        config.allowUnfree = true;
      };
      # Argumentos extras
      extraSpecialArgs = {
        inherit inputs spicetify-nix affinity-nix;
      };
      # home-manager
      commonHomeModules = [
        ./home.nix
        nix-flatpak.homeManagerModules.nix-flatpak
        spicetify-nix.homeManagerModules.default
      ];
    in
    {
      #/--------------------/ Sistema /--------------------/#
      nixosConfigurations.NeoReaper = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = extraSpecialArgs;
        modules = [
          { nixpkgs = basePkgsConfig; }
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.xardec = {
                imports = commonHomeModules;
                _module.args = { inherit spicetify-nix affinity-nix; };
              };
              extraSpecialArgs = extraSpecialArgs;
            };
          }
        ];
      };

      #/--------------------/ home-manager /--------------------/#
      homeConfigurations.xardec = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-stable {
          inherit system;
          inherit (basePkgsConfig) overlays config;
        };
        inherit extraSpecialArgs;
        modules = commonHomeModules ++ [
          { nixpkgs = basePkgsConfig; }
        ];
      };
    };
}
