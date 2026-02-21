{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  #/--------------------/ Versión y Locale /--------------------/#
  system.stateVersion = "25.11";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";

  #/--------------------/ Nix Configuration /--------------------/#
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      cores = 1;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  #/--------------------/ Boot Configuration /--------------------/#
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    
    plymouth = {
      enable = true;
      theme = "fade-in";
    };
    
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    
    # Optimización de Memoria
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
    };
  };

  #/--------------------/ ZRAM Configuration /--------------------/#
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 150;
    priority = 100;
  };

  #/--------------------/ Networking /--------------------/#
  networking = {
    hostName = "PC-Hogar";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 4242 ];
      allowedUDPPorts = [ 4242 ];
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

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "hourly";
      prunePaths = [
        "/tmp"
        "/var/tmp"
        "/home/.cache"
      ];
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
    zsh.enable = true;
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

  #/--------------------/ Users /--------------------/#
  users = {
    defaultUserShell = pkgs.zsh;
    
    users.xardec = {
      isNormalUser = true;
      description = "Xavier Del Piero";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };

  #/--------------------/ Auto-start Sway /--------------------/#
  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';
}
