{
  pkgs,
  lib,
  config,
  ...
}:
let
  category = "sistema";
  subcategory = "escritorio";
  moduleName = "sway";
in
{
  options.modulos.${category}.${subcategory}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${subcategory}.${moduleName}.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    environment.loginShellInit = ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };
}
