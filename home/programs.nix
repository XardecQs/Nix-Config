{
  config,
  pkgs,
  spicetify-nix,
  ...
}:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs = {
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        droidcam-obs
      ];
    };

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
}
