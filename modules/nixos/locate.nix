{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modulos.sistema.locate.enable = lib.mkEnableOption "locate";

  config = lib.mkIf config.modulos.sistema.locate.enable {
    services = {
      locate = {
        enable = true;
        package = pkgs.plocate;
        interval = "hourly";
        prunePaths = [
          "/tmp"
          "/var/tmp"
          "/home/.cache"
        ];
      };
    };
  };
}
