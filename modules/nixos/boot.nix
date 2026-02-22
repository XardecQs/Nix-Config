{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modulos.sistema.boot.enable = lib.mkEnableOption "boot";

  config = lib.mkIf config.modulos.sistema.boot.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      plymouth.enable = true;
      loader = {
        timeout = 0;
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
          consoleMode = "max";
        };
      };
    };
  };
}