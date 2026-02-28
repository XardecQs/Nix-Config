{
  pkgs,
  lib,
  config,
  ...
}:
let
  category = "sistema";
  subcategory = "escritorio";
  moduleName = "gnome";
in
{
  options.modulos.${category}.${subcategory}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${subcategory}.${moduleName}.enable {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
