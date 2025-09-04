{
  config,
  lib,
  pkgs,
  zen-browser,
  spicetify-nix,
  ...
}:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in

{
  home.packages = with pkgs; [
    # CLI tools
    bat
    btop
    eza
    fastfetch
    fzf
    lsd
    zoxide
    ripgrep
    fd
    unzip
    wl-clipboard
    unimatrix
    tmux
    dpkg
    tree
    zsh-powerlevel10k
    jp2a
    libicns

    # Desktop environment tools
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.gsconnect
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.maximize-to-empty-workspace-2025
    gnomeExtensions.fullscreen-hot-corner
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.emoji-copy
    gnomeExtensions.logo-menu

    dconf-editor
    kitty
    github-desktop
    adw-gtk3
    switcheroo
    zenity
    ffmpegthumbnailer
    jellyfin-ffmpeg
    vlc
    menulibre

    # Multimedia and design
    krita
    inkscape
    firefox

    # Themes
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    marble-shell-theme
    adwaita-qt6

    # Development tools
    nodejs
    python3

    # Nix management
    home-manager

    # Printer drivers
    epson-escpr2

    # Containerization
    podman
    distrobox

    # Development and utilities
    vscode
    gthumb
    nixfmt-rfc-style
    texliveMedium

    # Gaming and emulation
    wineWowPackages.stagingFull
    winetricks
    steam
    lutris
    mangohud
    protonup
    prismlauncher
    mcaselector

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
    #spotify

    # Miscellaneous
    icoextract
    android-tools
    alsa-utils
    syncthing
    zapzap
    discord
    telegram-desktop
    blender
    waydroid

    (zen-browser.packages."${pkgs.system}".default)
  ];

  services.syncthing = {
    enable = true;
    settings = {
      options = {
        urAccepted = -1;
      };
    };
  };

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
}
