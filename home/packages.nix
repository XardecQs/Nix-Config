{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI & Utilidades
    git
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
    gcc
    binutils
    gnumake
    cmake
    nodejs
    python3
    nixfmt-rfc-style
    texliveFull
    rustup
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
    unstable.prismlauncher
    unstable.lutris
    unstable.heroic
    unstable.mcaselector
    snes9x-gtk

    # Comunicación y misc
    qbittorrent
    peazip
    resources
    gnome-network-displays
    hydralauncher
    waydroid
    waydroid-helper
  ];
}
