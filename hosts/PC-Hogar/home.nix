{
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "xardec";
  homeDir = "/home/${username}";
  dotfiles = "${homeDir}/.dotfiles";

  # Función para crear symlinks fuera del Nix Store
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Mapeo de archivos de configuración
  configs = {
    ".config/nvim" = "config/nvim";
    ".config/kitty" = "config/kitty";
    ".config/fastfetch" = "config/fastfetch";
    ".config/zsh" = "config/zsh";
    ".config/tmux" = "config/tmux";
    ".config/user-dirs.dirs" = "config/user-dirs.dirs";
    ".icons" = "homedots/icons";
    ".local/share/icons" = "homedots/icons";
    ".local/share/fonts" = "homedots/fonts";
    ".vscode" = "homedots/vscode";
    ".zshrc" = "homedots/zshrc";
    ".config/alacritty" = "config/alacritty";
    ".config/sway" = "config/sway";
    ".config/waybar" = "config/waybar";
    ".config/wal" = "config/wal";
  };
in
{
  #/--------------------/ Home Manager Settings /--------------------/#
  home = {
    stateVersion = "25.11";
    username = username;
    homeDirectory = homeDir;

    packages = with pkgs; [
      alacritty
      gcc
      git
      github-desktop
      gnumake
      imagemagick
      libretro.mgba
      libretro.neocd
      libretro.snes9x
      librewolf
      nautilus
      nodejs
      papirus-icon-theme
      pciutils
      python3
      pywal16
      ripgrep
      rofi
      unimatrix
      usbutils
      waybar
      wofi
      xfce.xfce4-appfinder
      xfce.xfdesktop
    ];
  };

  #/--------------------/ Activation Scripts /--------------------/#
  home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${dotfiles}" ]; then
      echo "Clonando dotfiles desde GitHub..."
      ${pkgs.git}/bin/git clone https://github.com/XardecQs/dotfiles.git "${dotfiles}"
    else
      echo "Dotfiles ya existen en ${dotfiles}"
    fi
  '';

  #/--------------------/ Dotfiles Symlinks /--------------------/#
  home.file = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  #/--------------------/ Program Configuration /--------------------/#
  programs.retroarch.enable = true;
}
