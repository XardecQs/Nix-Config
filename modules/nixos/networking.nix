{ lib, config, ... }:
{
  options.modulos.sistema.networking.enable = lib.mkEnableOption "Networking";

  config = lib.mkIf config.modulos.sistema.networking.enable {
    networking = {
      networkmanager.enable = true;
      firewall = {
        allowedTCPPorts = [ 4242 ];
        allowedUDPPorts = [ 4242 ];
      };
    };
  };
}
