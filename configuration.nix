{ config, pkgs, ... }:

{
  #/----------/ general /----------/#
  imports = [
    ./hardware-configuration.nix
    #./modules/system/boot.nix
    #./modules/system/SysPakages.nix
    #./modules/system/users.nix
    #./modules/system/services.nix
    #./modules/system/zsh.nix
  ];

  # Configuración básica del sistema
  system.stateVersion = "25.05";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";
  nixpkgs.config.allowUnfree = true;
  #system.autoUpgrade.enable = true;

  # Red
  networking = {
    hostName = "NeoReaper";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation = {
    waydroid.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
  };
  #/----------/ boot /----------/#
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
    plymouth = {
      enable = true;
    };
  };
  #/----------/ services /----------/#

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
    #xserver.desktopManager.cinnamon.enable = true;
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
      drivers = [ pkgs.epson-escpr ];
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

  #/----------/ paquetes del sistema /----------/#

  environment.systemPackages = with pkgs; [
    fzf
    zoxide
    lsd
    git
    wget
    neovim
    btrfs-progs
    gparted
    openssh
    fastfetch
    kitty
    cups
    epson-escpr2
    tree
    gdu
    yazi
    syncthing
    bindfs

    nautilus-python
    nautilus-open-any-terminal

    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-fzf-tab

    gcc
    binutils
    gnumake
    cmake

    gamemode

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
  };
  #/----------/ usuarios /----------/#

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
      ];
    };

    groups = {
      libvirtd.members = [ "xardec" ];
      xardec = {
        name = "xardec";
        gid = 1000;
        members = [ "xardec" ];
      };
    };
  };

  #/----------/ zsh /----------/#

  programs.zsh = {
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
}
