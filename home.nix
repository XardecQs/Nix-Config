{
  config,
  pkgs,
  lib,
  zen-browser,
  spicetify-nix,
  winboat,
  ...
}:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    # final (relativo a home) = origen (~/.dotfiles); #
    ".config/nvim" = "config/nvim";
    ".config/kitty" = "config/kitty";
    ".config/fastfetch" = "config/fastfetch";
    ".config/zsh" = "config/zsh";
    ".config/user-dirs.dirs" = "config/user-dirs.dirs";
    ".icons" = "homedots/icons";
    ".local/share/icons" = "homedots/icons";
    ".vscode" = "homedots/vscode";
    ".config/tmux" = "config/tmux";
    ".local/share/fonts" = "fonts";
  };
in
{
  home = {
    stateVersion = "25.05";
    username = "xardec";
    homeDirectory = "/home/xardec";
  };

  # Archivos de configuración
  home.file = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  # GNOME
  services.gnome-keyring.enable = true;

  gtk = {
    enable = true;
    #iconTheme.name = "Definitivo";
    cursorTheme.name = "MacOS-Tahoe-Cursor";
    #theme = {
    #  name = "adw-gtk3-dark";
    #  package = pkgs.adw-gtk3;
    #};
    font.name = "SF Pro Display";
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      #color-scheme = "prefer-dark";
      #gtk-theme = "adw-gtk3-dark";
    };
    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        maximize-to-empty-workspace-2025.extensionUuid
        dash-to-dock.extensionUuid
        show-desktop-button.extensionUuid
        user-themes.extensionUuid
        gsconnect.extensionUuid
        blur-my-shell.extensionUuid
        gtk4-desktop-icons-ng-ding.extensionUuid
        rounded-window-corners-reborn.extensionUuid
        clipboard-indicator.extensionUuid
        fullscreen-hot-corner.extensionUuid
        caffeine.extensionUuid
        tray-icons-reloaded.extensionUuid
        emoji-copy.extensionUuid
        logo-menu.extensionUuid
        auto-adwaita-colors.extensionUuid
      ];
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-blue-dark";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Kitty";
      command = "kitty";
      binding = "<Super>q";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Open Nautilus";
      command = "nautilus";
      binding = "<Super>e";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "wallpaper aleatorio";
      command = "/home/xardec/Proyectos/Scripts/sh/gnome-wallpaper.sh 'Imagen aleatoria'";
      binding = "<Super><Shift>w";
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
    };
  };

  # Paquetes de usuario
  home.packages = with pkgs; [
    # CLI tools
    git
    wget
    neovim
    bat
    btop
    fzf
    zsh-fzf-tab
    fd
    unzip
    wl-clipboard
    unimatrix
    tmux
    zsh-powerlevel10k
    jp2a
    libicns
    zoxide
    lsd
    fastfetch
    gdu
    yazi

    # Desktop environment
    kitty
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.gsconnect
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.maximize-to-empty-workspace-2025
    gnomeExtensions.auto-adwaita-colors
    gnomeExtensions.fullscreen-hot-corner
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.emoji-copy
    gnomeExtensions.logo-menu
    dconf-editor
    github-desktop
    switcheroo
    zenity
    ffmpegthumbnailer
    jellyfin-ffmpeg
    menulibre
    nautilus-python
    nautilus-open-any-terminal

    # Multimedia and design
    krita
    inkscape

    # Themes
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    marble-shell-theme
    adw-gtk3

    # Development tools
    gcc
    binutils
    gnumake
    cmake
    nodejs
    python3
    home-manager
    nixfmt-rfc-style
    texliveFull

    # Containerization
    podman
    distrobox

    # Development and utilities
    unstable.vscode
    gthumb
    onlyoffice-desktopeditors

    # Gaming and emulation
    wineWowPackages.stagingFull
    winetricks
    unstable.lutris
    mangohud
    protonup
    unstable.prismlauncher
    mcaselector
    gamemode

    # Virtualization
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

    # AI and image processing
    realcugan-ncnn-vulkan
    realesrgan-ncnn-vulkan

    # Media
    youtube-music

    # Miscellaneous
    icoextract
    android-tools
    alsa-utils
    zapzap
    discord
    telegram-desktop
    blender
    waydroid
    waydroid-helper
    rustup
    glibc.static
    upx
    arduino
    arduino-cli
    gnome-network-displays
    hydralauncher
    cava
    gapless
    desktop-file-utils
    resources
    anki
    obsidian
    showtime

    (zen-browser.packages."${pkgs.system}".default)
    ungoogled-chromium

    unstable.audacity
    unstable.libresprite
    unstable.iconic
    unstable.godot
    
    (winboat.packages.${system}.winboat)
    hardinfo2
    easyeffects
    losslesscut-bin
    qbittorrent
    peazip
    appimage-run
  ];

  # Syncthing
  services.syncthing = {
    enable = true;
    extraOptions = [ "--allow-newer-config" ];
    settings = {
      options.urAccepted = -1;
      devices = {
        "Redmi Note 10 Pro" = {
          id = "C74GATB-E337PHR-EVNK36T-ZPDD4JY-I4HHD2K-MFVFPTK-36J2R7I-MHSBRQ2";
        };
      };
      folders = {
        "Kotatsu" = {
          path = "/home/xardec/Media/Mangas/.Kotatsu";
          id = "tovx9-9995f";
          devices = [ "Redmi Note 10 Pro" ];
        };
        "Música" = {
          path = "/home/xardec/Media/Música";
          id = "w9yjz-9kb76";
          devices = [ "Redmi Note 10 Pro" ];
        };
        "Capturas de pantalla" = {
          path = "/home/xardec/Media/Imágenes/Capturas de pantalla";
          id = "7979p-4pjv5";
          devices = [ "Redmi Note 10 Pro" ];
        };
      };
    };
  };

  programs.obs-studio = {
    enable = true;
    #enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      droidcam-obs
    ];
  };

  # Spicetify
  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      fullAppDisplay
      beautifulLyrics
      shuffle
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      marketplace
      betterLibrary
    ];
  };

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
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
      nix-shell = "nix-shell --command zsh";
    };

    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
}
