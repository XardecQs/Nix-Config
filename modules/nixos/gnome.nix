{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modulos.sistema.gnome.enable = lib.mkEnableOption "gnome";

  config = lib.mkIf config.modulos.sistema.gnome.enable {
    services = {
      displayManager.gdm = {
        enable = true;
      };
      desktopManager.gnome.enable = true;
    };

    programs = {
      kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
    };
  };
}
