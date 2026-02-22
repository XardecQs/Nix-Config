{ lib, config, ... }:
{
  options.modulos.sistema.steam.enable = lib.mkEnableOption "Steam y añadidos";

  config = lib.mkIf config.modulos.sistema.steam.enable {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      gamemode.enable = true;
    };
  };
}
