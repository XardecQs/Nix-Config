{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modulos.home-manager.obs.enable = lib.mkEnableOption "obs";

  config = lib.mkIf config.modulos.home-manager.obs.enable {
    programs = {
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
          droidcam-obs
        ];
      };
    };
  };
}
