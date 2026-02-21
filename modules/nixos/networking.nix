{ ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 4242 ];
      allowedUDPPorts = [ 4242 ];
    };
  };
}
