{ lib, config, ... }:
let
  category = "sistema"; # [ sistema | home-manager ]
  moduleName = "nix";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
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
      }
      // lib.optionalAttrs (config.networking.hostName == "PC-Hogar") {
        cores = 1;
      };
    };
    programs = {
      nix-ld.enable = true;
      appimage = {
        enable = true;
        binfmt = true;
      };
    };
  };
}
