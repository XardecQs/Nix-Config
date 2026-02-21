{ config, pkgs, lib, ... }:

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
    xfce.xfdesktop
    xfce.xfce4-appfinder
    github-desktop
    librewolf
    nautilus
    rofi
    waybar
    pywal16
    imagemagick
    unimatrix
    libretro.snes9x
    libretro.neocd
    libretro.mgba
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

  # Descomenta según necesites
  # programs = {
  #   git = {
  #     enable = true;
  #     userName = "XardecQs";
  #     userEmail = "tu@email.com";
  #   };
  #   
  #   zsh = {
  #     enable = true;
  #     # Configuración adicional de zsh
  #   };
  #   
  #   neovim = {
  #     enable = true;
  #     # Configuración adicional de neovim
  #   };
  # };
}
