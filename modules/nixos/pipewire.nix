{ lib, config, ... }:

let
  category = "sistema"; # [ sistema | home-manager ]
  moduleName = "pipewire";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
    services = {
      pipewire = {
        enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };
  };
}
