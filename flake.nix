{
  description = "Configuración NixOS modular para NeoReaper y PC-Hogar";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Overlay para acceder a paquetes unstable fácilmente
      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      # Función para generar la configuración de cada PC
      mkHost =
        hostname: extraModules:
        nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            # 1. Punto de entrada de cada host (configuration.nix específico)
            ./hosts/${hostname}/configuration.nix

            # 3. Integración de Home Manager
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ unstableOverlay ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };

                # Cargamos el home.nix específico del host
                users.xardec = {
                  imports = [
                    ./hosts/${hostname}/home.nix
                    inputs.spicetify-nix.homeManagerModules.default
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                  ];
                };
              };
            }
          ]
          ++ extraModules;
        };

    in
    {
      nixosConfigurations = {
        NeoReaper = mkHost "NeoReaper" [ ];
        PC-Hogar = mkHost "PC-Hogar" [ ];
      };
    };
}
