{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Configuración básica del sistema
  system.stateVersion = "25.05";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";
  nixpkgs.config.allowUnfree = true;

  # Red
  networking = {
    hostName = "NeoReaper";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_testing;
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
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;

    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      xkb.layout = "latam";
      videoDrivers = [ "intel" ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "daily";
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

  security.rtkit.enable = true;

  # Paquetes del sistema
  environment.systemPackages = with pkgs; [
    # Herramientas básicas
    git
    wget
    neovim
    btrfs-progs
    gparted
    openssh
    tree
    bindfs

    # Utilidades del sistema
    fzf
    zoxide
    lsd
    fastfetch
    kitty
    cups
    epson-escpr2
    gdu
    yazi
    syncthing

    # Nautilus
    nautilus-python
    nautilus-open-any-terminal

    # ZSH
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-fzf-tab

    # Desarrollo
    gcc
    binutils
    gnumake
    cmake

    # Juegos
    gamemode

    # Virtualización
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    freerdp
    qemu
    libvirt
    swtpm
  ];

  # Programas
  programs = {
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
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      interactiveShellInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        HISTSIZE=10000
        HISTFILE=~/.local/share/zsh/history
        SAVEHIST=$HISTSIZE

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

        [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh
      '';

      shellAliases = {
        lla = "lsd -la";
        la = "lsd -a";
        ll = "lsd -l";
        ls = "lsd";
        q = "exit";
        c = "clear";
        ".." = "cd ..";
        "..." = "cd ../..";
        cf = "clear && fastfetch";
        cff = "clear && fastfetch --config /etc/nixos/modules/users/xardec/dotfiles/config/fastfetch/13-custom.jsonc";
        snvim = "sudo nvim";
        ordenar = "~/Proyectos/Scripts/sh/ordenar.sh";
        desordenar = "~/Proyectos/Scripts/sh/desordenar.sh";
        cp = "cp --reflink=auto";
        umatrix = "unimatrix -s 95 -f";
        grep = "grep --color=auto";
        diff = "diff --color=auto";
        syu = "yay -Syu";
        codepwd = ''code "$(pwd)"'';
        napwd = ''nautilus "$(pwd)" &> /dev/null & disown'';
        dots = "cd ~/.dotfiles && codepwd && q";
        dotsn = "cd ~/.dotfiles && nvim";
      };
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
        "xardec"
        "libvirtd"
      ];
    };

    groups.xardec = {
      name = "xardec";
      gid = 1000;
      members = [ "xardec" ];
    };
  };
}
