{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  networking.hostName = "PC-Hogar";

  modulos = {
    sistema = {
      boot.enable = true;
      general.enable = true;
      gnome.enable = false;
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

  nix = {
    settings = {
      cores = 1;
    };
  };

  #/--------------------/ Services /--------------------/#
  services = {
    openssh.enable = true;
    thermald.enable = true;
    displayManager.ly.enable = false;
    getty = {
      autologinUser = "xardec";
      autologinOnce = true;
    };
    gnome.gnome-keyring.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  #/--------------------/ Programs /--------------------/#
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };
  #/--------------------/ Auto-start Sway /--------------------/#
  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';
}
