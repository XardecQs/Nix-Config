{ config, pkgs, ... }:
{
  imports = [
    ./hosts/NeoReaper/hardware-configuration.nix
    ./modules/nixos
  ];

    
  networking.hostName = "NeoReaper";
  system.stateVersion = "25.11";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";

  #/--------------------/ Red /--------------------/#
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 4242 ];
      allowedUDPPorts = [ 4242 ];
    };
  };

  #/--------------------/ Boot /--------------------/#
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth.enable = true;
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };

    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      #grub = {
      #  enable = true;
      #  efiSupport = true;
      #  device = "nodev";
      #  useOSProber = true;
      #};
    };
  };

  #/--------------------/ Hardware y gráficos /--------------------/#
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };

  #/--------------------/ Virtualización y contenedores /--------------------/#
  virtualisation = {
    waydroid.enable = true;
    libvirtd.enable = true;
    docker.enable = true;
  };

  #/--------------------/ Servicios principales /--------------------/#
  services = {
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "";
        CPU_SCALING_GOVERNOR_ON_BAT = "";
        CPU_ENERGY_PERF_POLICY_ON_AC = "";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "";
        CPU_BOOST_ON_AC = "";
        CPU_BOOST_ON_BAT = "";

        USB_AUTOSUSPEND = 1;
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        INTEL_GPU_MIN_FREQ_ON_BAT = 300;
      };
    };
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    upower.enable = true;
    flatpak.enable = true;
    sshd.enable = true;

    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome.enable = true;

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

    spice-vdagentd.enable = true;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    allowUserNamespaces = true;
  };

  #/--------------------/ Paquetes del sistema (mínimos) /--------------------/#
  environment.systemPackages = with pkgs; [
    btrfs-progs
    gparted
    bindfs
    kitty
    wget
    tree
    bat
    btop
    fzf
    fd
    unzip
    wl-clipboard
    unimatrix
    tmux
    zoxide
    lsd
    fastfetch
    gdu
    yazi
    entr
    direnv
    nixd
    nil
    nix-ld
    bubblewrap
    neovim
    lan-mouse
  ];

  #/--------------------/ Programas habilitados /--------------------/#
  programs = {
    firejail.enable = true;
    obs-studio.enableVirtualCamera = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    nix-ld.enable = true;
    gamemode.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    zsh.enable = true;
    sway.enable = true;
  };

  #/--------------------/ Usuarios y grupos /--------------------/#
  users = {
    defaultUserShell = pkgs.zsh;
    users.root.shell = pkgs.zsh;
    users.xardec = {
      isNormalUser = true;
      description = "Xavier Del Piero";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "dialout"
        "waydroid"
        "docker"
      ];
    };
    # Usuarios/grupos de Waydroid (necesarios)
    users.waydroid-xardec = {
      isSystemUser = true;
      uid = 10121;
      group = "waydroid";
      home = "/var/empty";
      shell = "/run/current-system/sw/bin/nologin";
    };
    users.waydroid-root = {
      isSystemUser = true;
      uid = 1023;
      group = "waydroid";
      home = "/var/empty";
      shell = "/run/current-system/sw/bin/nologin";
    };
    groups.waydroid.gid = 1023;
  };

  environment.etc = {
    "wayland-sessions/mi-sesion-custom.desktop".text = ''
      [Desktop Entry]
      Name=Mi Sesión Custom Wayland
      Comment=Wayland con flags especiales
      Exec=/run/current-system/sw/bin/gamescope --adaptive-sync --exit-on-last-window -- steam -gamepadui -steamos

      Type=Application
      DesktopNames=CustomWayland
    '';
  };

  #/--------------------/ Bindfs (opcional para Waydroid) - Comentado /--------------------/#
  # fileSystems = { ... };  # Descomenta si necesitas compartir carpetas con Waydroid
}
