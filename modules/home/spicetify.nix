{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.modulos.home-manager.spicetify.enable = lib.mkEnableOption "spicetify";

  config = lib.mkIf config.modulos.home-manager.spicetify.enable {
    programs = {
      spicetify = {
        enable = true;
        alwaysEnableDevTools = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          fullAppDisplay
          beautifulLyrics
          shuffle
        ];
        enabledCustomApps = with spicePkgs.apps; [
          lyricsPlus
          marketplace
          betterLibrary
        ];
      };
    };
  };
}