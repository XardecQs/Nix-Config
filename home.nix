{
  config,
  pkgs,
  lib,
  ...
}:

let
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
    ".config/Code/User/settings.json" = "homedots/vscode/settings.json";
    ".config/tmux" = "config/tmux";
    ".local/share/fonts" = "homedots/fonts";
    ".zshrc" = "homedots/zshrc";
  };
in
{
  imports = [
    ./home/gnome.nix
    ./home/features.nix
  ];

  home = {
    stateVersion = "25.11";
    username = "xardec";
    homeDirectory = "/home/xardec";
  };

  # Clonación de dotfiles
  home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${dotfiles}" ]; then
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/XardecQs/dotfiles.git "${dotfiles}"
    fi
  '';

  # Symlinks a tus dotfiles
  home.file = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
