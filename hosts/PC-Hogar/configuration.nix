{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  networking.hostName = "PC-Hogar";

  modulos = {
    sistema = {
      escritorio = {
        gnome.enable = false;
        sway.enable = true;
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
    };
  };

  #/--------------------/ Services /--------------------/#
  services = {
    openssh.enable = true;
    thermald.enable = true;
    getty = {
      autologinUser = "xardec";
      autologinOnce = true;
    };
    gnome.gnome-keyring.enable = true;
  };
}
