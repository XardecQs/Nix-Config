{
  pkgs,
  lib,
  config,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    # final (relativo a home) = origen (absoluto desde dotfiles) #
    ".config/nvim" = "${dotfiles}/config/nvim";
    ".config/kitty" = "${dotfiles}/config/kitty";
    ".config/fastfetch" = "${dotfiles}/config/fastfetch";
    ".config/zsh" = "${dotfiles}/config/zsh";
    ".config/user-dirs.dirs" = "${dotfiles}/config/user-dirs.dirs";
    ".icons" = "${dotfiles}/homedots/icons";
    ".local/share/icons" = "${dotfiles}/homedots/icons";
    ".config/Code/User/settings.json" = "${dotfiles}/config/code/settings.json";
    ".config/tmux" = "${dotfiles}/config/tmux";
    ".zshrc" = "${dotfiles}/homedots/zshrc";
    ".config/alacritty" = "${dotfiles}/config/alacritty";
    ".config/sway" = "${dotfiles}/config/sway";
    ".config/waybar" = "${dotfiles}/config/waybar";
    ".config/wal" = "${dotfiles}/config/wal";
  };
in
{
  options.modulos.home-manager.dotfiles.enable = lib.mkEnableOption "dotfiles";
  config = lib.mkIf config.modulos.home-manager.dotfiles.enable {
    home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "${dotfiles}" ]; then
        ${pkgs.git}/bin/git clone --depth 1 https://github.com/XardecQs/dotfiles.git "${dotfiles}"
      fi
    '';
    home.activation.cloneFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      fonts_dir="$HOME/.local/share/fonts"
      if [ ! -d "$fonts_dir" ] || [ -z "$(ls -A "$fonts_dir" 2>/dev/null)" ]; then
        ${pkgs.git}/bin/git clone --depth 1 https://github.com/XardecQs/font-collection.git "$fonts_dir"
      fi
    '';
    home.file = builtins.mapAttrs (name: abspath: {
      source = create_symlink abspath;
      recursive = true;
    }) configs;
  };
}
