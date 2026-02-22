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
      btrfs-progs
      gparted
      bindfs
      kitty
      wget
      tree
      bat
      btop
      fzf
      fd
      unzip
      wl-clipboard
      unimatrix
      tmux
      zoxide
      lsd
      fastfetch
      gdu
      yazi
      entr
      direnv
      nixd
      nil
      nix-ld
      bubblewrap
      neovim
      lan-mouse
    ];
  };
}
