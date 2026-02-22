{ lib, config, ... }:
{
  options.modulos.sistema.nix.enable = lib.mkEnableOption "Configuraciones de Nix";

  config = lib.mkIf config.modulos.sistema.nix.enable {
    nixpkgs.config.allowUnfree = true;
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        warn-dirty = false;
      };
    };
  };
}
