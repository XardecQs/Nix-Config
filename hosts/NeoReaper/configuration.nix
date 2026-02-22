{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  networking.hostName = "NeoReaper";
  
  modulos = {
    sistema = {
      boot.enable = true;
      general.enable = true;
      gnome.enable = true;
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

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    allowUserNamespaces = true;
  };

  #/--------------------/ Programas habilitados /--------------------/#
  programs = {
    firejail.enable = true;
    obs-studio.enableVirtualCamera = true;
    nix-ld.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    sway.enable = true;
  };

}
