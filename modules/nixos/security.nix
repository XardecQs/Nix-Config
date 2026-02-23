{ lib, config, ... }:

let
  category = "sistema"; # [ sistema | home-manager ]
  moduleName = "security";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
    security = {
      rtkit.enable = true;
      polkit.enable = true;
      allowUserNamespaces = true;
      pam.services.login.enableGnomeKeyring = true;
    };
  };
}
