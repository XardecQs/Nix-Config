{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  networking.hostName = "NeoReaper";

  modulos = {
    sistema = {
      escritorio = {
        gnome.enable = true;
        sway.enable = false;
      };
      boot.enable = true;
      general.enable = true;
      intel-gpu.enable = true;
      laptop.enable = true;
      locate.enable = true;
      networking.enable = true;
      nix.enable = true;
      steam.enable = true;
      systemPackages.enable = true;
      users.enable = true;
      virtualisation.enable = true;
      waydroid.enable = true;
      pipewire.enable = true;
      security.enable = true;
    };
  };

  #/--------------------/ Servicios principales /--------------------/#
  services = {
    flatpak.enable = true;
    sshd.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "latam";
      videoDrivers = [ "intel" ];
    };

    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
  };

  #/--------------------/ Programas habilitados /--------------------/#
  programs = {
    firejail.enable = true;
    obs-studio.enableVirtualCamera = true;
  };

}
