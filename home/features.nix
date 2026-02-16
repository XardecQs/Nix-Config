{
  pkgs,
  spicetify-nix,
  ...
}:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    # CLI & Utilidades
    git
    gh
    wget
    bat
    btop
    fzf
    fd
    unzip
    unimatrix
    tmux
    jp2a
    libicns
    zoxide
    lsd
    fastfetch
    gdu
    yazi
    home-manager
    p7zip

    # Aplicaciones de escritorio
    kitty
    gnome-tweaks
    gnome-extension-manager
    dconf-editor
    github-desktop
    zenity
    menulibre
    nautilus-python

    # Extensiones GNOME (instaladas como paquetes)
    gnomeExtensions.gsconnect
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.auto-adwaita-colors
    gnomeExtensions.fullscreen-hot-corner
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.emoji-copy
    gnomeExtensions.logo-menu
    unstable.gnomeExtensions.maximize-window-into-new-workspace
    unstable.gnomeExtensions.gtk4-desktop-icons-ng-ding

    # Multimedia
    krita
    inkscape
    ffmpegthumbnailer
    gthumb
    unstable.audacity
    unstable.libresprite
    blender
    losslesscut-bin
    cava
    youtube-music
    easyeffects

    # Desarrollo
    binutils
    gnumake
    cmake
    nodejs
    python3
    nixfmt-rfc-style
    texliveFull
    cargo
    rust-analyzer
    rustfmt
    clippy
    pkg-config
    openssl
    gcc
    rustc
    glibc.static
    upx
    arduino
    arduino-cli
    unstable.vscode
    unstable.godot

    # Sistema y virtualización
    podman
    distrobox
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    freerdp
    qemu
    libvirt
    swtpm
    realcugan-ncnn-vulkan
    realesrgan-ncnn-vulkan
    android-tools
    alsa-utils
    desktop-file-utils
    appimage-run
    hardinfo2
    gamemode
    mangohud

    # Temas y fuentes
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    marble-shell-theme
    adw-gtk3

    # Gaming
    wineWowPackages.stableFull
    winetricks
    protonup-ng
    unstable.lutris
    unstable.heroic
    snes9x-gtk
    mangohud

    # Comunicación y misc
    qbittorrent
    peazip
    resources
    gnome-network-displays
    hydralauncher
    waydroid
    waydroid-helper
  ];

  services = {
    flatpak = {
      enable = true;
      packages = [
        "com.github.tchx84.Flatseal"
        "com.github.johnfactotum.Foliate"
        "app.zen_browser.zen"
        "md.obsidian.Obsidian"
        "net.blockbench.Blockbench"
        "io.gitlab.adhami3310.Converter"
        "org.nickvision.tubeconverter"
        "org.kde.kdenlive"
        "com.github.neithern.g4music"
        "com.rtosta.zapzap"
        "org.onlyoffice.desktopeditors"
        "it.mijorus.gearlever"
        "io.github.Querz.mcaselector"
      ];
    };
  };
  programs = {
    java = {
      enable = true;
      package = pkgs.zulu25.override {
        enableJavaFX = true;
      };
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        droidcam-obs
      ];
    };

    spicetify = {
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
  };

  services = {
    syncthing = {
      enable = true;
      extraOptions = [ "--allow-newer-config" ];
      settings = {
        options.urAccepted = -1;
        devices = {
          "Redmi Note 10 Pro" = {
            id = "CKKQFLP-DHF2EVH-DTYRSR3-JE4EPTH-CZF2P6S-56VFBL5-55E4GYA-EF7CWQJ";
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
  };
}
