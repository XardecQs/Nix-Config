{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  category = "home-manager"; # [ sistema | home-manager ]
  moduleName = "lan-mouse";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
    home.packages = [
      inputs.lan-mouse.packages.${pkgs.system}.default
    ];
  };
}
