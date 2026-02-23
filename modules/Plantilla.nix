{ lib, config, ... }:

let
  category = ""; # [ sistema | home-manager ]
  moduleName = "";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
  };
}
