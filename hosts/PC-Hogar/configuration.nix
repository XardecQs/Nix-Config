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
      systemPackages.enable = false;
      users.enable = true;
      virtualisation.enable = false;
      waydroid.enable = false;
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
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.pam.services.login.enableGnomeKeyring = true;
  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  #/--------------------/ Programs /--------------------/#
  programs = {
    nix-ld.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  #/--------------------/ System Packages /--------------------/#
  environment.systemPackages = with pkgs; [
    # Core Tools
    wget
    git
    neovim
    btop
    tmux
    fastfetch

    # System Utilities
    pciutils
    usbutils
    gdu

    # Shell Enhancements
    zoxide
    lsd
    yazi
    fzf
    bat
    ripgrep

    # Terminal & Editor
    alacritty
    gcc
    gnumake
    unzip

    # Development
    nodejs
    python3
    nixd

    # Desktop Apps
    github-desktop
    librewolf
    nautilus

    # Wayland Tools
    wl-clipboard
    wofi

    # Theming
    papirus-icon-theme
    adw-gtk3

    # XFCE Components
    xfce.xfdesktop
    xfce.xfce4-appfinder

    lan-mouse
  ];

  #/--------------------/ Auto-start Sway /--------------------/#
  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';
}
