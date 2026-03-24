{ lib, config, ... }:

let
  category = "sistema"; # [ sistema | home-manager ]
  moduleName = "servidor";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
    services = {
      auto-cpufreq = {
        enable = true;
        settings = {
          charger = {
            governor = "powersave";
            turbo = "never";
          };
        };
      };

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "";
          DISK_IDLE_SECS_ON_AC = 5;
          USB_AUTOSUSPEND = 1;
        };
      };
      power-profiles-daemon.enable = false;
      thermald.enable = true;
      upower.enable = true;
    };
  };
}
