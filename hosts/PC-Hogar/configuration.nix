{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  networking.hostName = "PC-Hogar";
  networking = {
    interfaces.enp3s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.199";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [
      "192.168.1.1"
      "8.8.8.8"
    ];
  };

  modulos = {
    sistema = {
      escritorio = {
        gnome.enable = false;
        sway.enable = false;
      };
      boot.enable = true;
      general.enable = true;
      intel-gpu.enable = true;
      laptop.enable = false;
      locate.enable = true;
      networking.enable = true;
      nix.enable = true;
      steam.enable = false;
      systemPackages.enable = true;
      users.enable = true;
      virtualisation.enable = false;
      waydroid.enable = false;
      pipewire.enable = true;
      security.enable = true;
      servidor.enable = true;
    };
  };

  #/--------------------/ Services /--------------------/#
  services = {
    openssh.enable = true;
    thermald.enable = true;
    #getty = {
    #  autologinUser = "xardec";
    #  autologinOnce = true;
    #};
    gnome.gnome-keyring.enable = true;
  };
}
