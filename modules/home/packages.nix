{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  elyWrapped = pkgs.symlinkJoin {
    name = "elyprismlauncher-wrapped";
    paths = [ inputs.elyprismlauncher.packages.${pkgs.system}.default ];  # o .elyprismlauncher si es el atributo
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/elyprismlauncher \
        --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" \
        --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    '';
  };
in
{
  options.modulos.home-manager.packages.enable = lib.mkEnableOption "packages";

  config = lib.mkIf config.modulos.home-manager.packages.enable {
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
      github-desktop
      zenity

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
      elyWrapped

      # Comunicación y misc
      qbittorrent
      peazip
      resources
      gnome-network-displays
      hydralauncher
    ];
  };
}
