{ lib, config, ... }:
{
  options.modulos.sistema.general.enable = lib.mkEnableOption "general";

  config = lib.mkIf config.modulos.sistema.general.enable {
    system.stateVersion = "25.11";
    time.timeZone = "America/Lima";
    i18n.defaultLocale = "es_PE.UTF-8";
    console.keyMap = "la-latin1";
  };
}