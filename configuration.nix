{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Configuración básica del sistema
  system.stateVersion = "25.05";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";

  # Gestión de paquetes y store
  nixpkgs.config.allowUnfree = true;

  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
    };
  };

  # Red
  networking = {
    hostName = "NeoReaper";
    networkmanager.enable = true;
  };

  # Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
    };
    plymouth.enable = true;
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  # Virtualización
  virtualisation = {
    waydroid.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    docker = {
      enable = true;
    };
  };

  # Hardware
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };

  # Servicios
  services = {
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
      #desktopManager.xterm.enable = false;
      xkb.layout = "latam";
      videoDrivers = [ "intel" ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true; # Explicit for advanced audio routing
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

    openssh.enable = false;
    pulseaudio.enable = false;
    spice-vdagentd.enable = true;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    seahorse
    gnome-system-monitor
    gnome-tour
    gnome-user-docs
    gnome-console
    totem
    epiphany
    yelp
  ];

  # Paquetes mínimos del sistema
  environment.systemPackages = with pkgs; [
    # Herramientas esenciales
    btrfs-progs
    gparted
    bindfs
    kitty

    wget
    neovim
    tree
    bat
    btop
    fzf
    fd
    unzip
    wl-clipboard
    unimatrix
    tmux
    zsh-powerlevel10k
    zoxide
    lsd
    fastfetch
    gdu
    yazi
    entr
    direnv
  ];

  # Programas
  programs = {
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
    gamemode.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        lla = "lsd -la";
        la = "lsd -a";
        ll = "lsd -l";
        l1 = "lsd -1";
        ls = "lsd";
        q = "exit";
        c = "clear";
        ".." = "cd ..";
        "..." = "cd ../..";
        cf = "clear && fastfetch";
        cff = "clear && fastfetch --config /home/xardec/.dotfiles/config/fastfetch/13-custom.jsonc";
        cp = "cp --reflink=auto";
        umatrix = "unimatrix -s 95 -f";
        grep = "grep --color=auto";
        diff = "diff --color=auto";
      };
      histFile = "$HOME/.local/share/zsh/history";
      histSize = 10000;
      interactiveShellInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh

        source <(fzf --zsh)
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(direnv hook zsh)"

        autoload -U select-word-style
        select-word-style bash

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.lsd}/bin/lsd --color=always $realpath'
        zstyle ':fzf-tab:*' fzf-flags --height=55% --border

        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
        bindkey '^H' backward-kill-word
        bindkey "^[[3~" delete-char

        EDITOR=nvim

        [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh

        if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
          exec tmux new-session -A
        fi
      '';
    };
  };

  # Usuarios
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
    users.waydroid-xardec = {
      isSystemUser = true;
      uid = 10121;
      group = "waydroid";
      description = "xardec en Waydroid";
      home = "/var/empty";
      shell = "/run/current-system/sw/bin/nologin";
    };
    users.waydroid-root = {
      isSystemUser = true;
      uid = 1023;
      group = "waydroid";
      description = "root de Waydroid";
      home = "/var/empty";
      shell = "/run/current-system/sw/bin/nologin";
    };
    groups.waydroid = {
      gid = 1023;
    };
  };

  fileSystems = {
    #"/home/xardec/.local/share/fonts" = {
    #  device = "/usr/share/fonts";
    #  fsType = "fuse.bindfs";
    #};

    "/home/xardec/.local/share/waydroid/data/media/0/Download" = {
      device = "/home/xardec/Descargas";
      fsType = "fuse.bindfs";
      options = [
        "uid=waydroid-xardec"
        "gid=waydroid"
        "create-for-user=xardec"
        "create-for-group=users"
        "user"
        "nofail"
      ];
    };
    "/home/xardec/.local/share/waydroid/data/media/0/Music" = {
      device = "/home/xardec/Media/Música";
      fsType = "fuse.bindfs";
      options = [
        "uid=waydroid-xardec"
        "gid=waydroid"
        "create-for-user=xardec"
        "create-for-group=users"
        "user"
        "nofail"
      ];
    };
    "/home/xardec/.local/share/waydroid/data/media/0/Documents" = {
      device = "/home/xardec/Documentos";
      fsType = "fuse.bindfs";
      options = [
        "uid=waydroid-xardec"
        "gid=waydroid"
        "create-for-user=xardec"
        "create-for-group=users"
        "user"
        "nofail"
      ];
    };
    "/home/xardec/.local/share/waydroid/data/media/0/Android/data/org.koitharu.kotatsu/files/manga" = {
      device = "/home/xardec/Media/Mangas/.Kotatsu";
      fsType = "fuse.bindfs";
      options = [
        "uid=10129"
        "gid=1078"
        "create-for-user=xardec"
        "create-for-group=users"
        "user"
        "nofail"
      ];
    };
  };
}
