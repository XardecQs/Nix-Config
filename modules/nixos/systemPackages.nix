{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modulos.sistema.systemPackages.enable = lib.mkEnableOption "systemPackages";

  config = lib.mkIf config.modulos.sistema.systemPackages.enable {
    environment.systemPackages = with pkgs; [
      adw-gtk3
      bat
      btop
      fastfetch
      fzf
      gdu
      lan-mouse
      lsd
      neovim
      nixd
      tmux
      unzip
      wget
      wl-clipboard
      yazi
      zoxide
      #---#
      bindfs
      btrfs-progs
      bubblewrap
      direnv
      entr
      fd
      gparted
      nil
      nix-ld
      tree
      unimatrix
    ];
  };
}
