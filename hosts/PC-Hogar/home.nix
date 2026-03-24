{ pkgs, ... }:
{
  imports = [
    ./../../modules/home
  ];
  #/--------------------/ Home Manager Settings /--------------------/#
  home = {
    stateVersion = "25.11";
    username = "xardec";
    homeDirectory = "/home/xardec";

    packages = with pkgs; [
      #alacritty
      gcc
      git
      #github-desktop
      gnumake
      imagemagick
      #libretro.mgba
      #libretro.neocd
      #libretro.snes9x
      #librewolf
      #nautilus
      nodejs
      #papirus-icon-theme
      pciutils
      python3
      pywal16
      ripgrep
      rofi
      #unimatrix
      usbutils
      #waybar
      #wofi
    ];
  };

  modulos = {
    home-manager = {
      dotfiles.enable = true;
      flatpak.enable = false;
      gnome.enable = false;
      java.enable = false;
      obs.enable = false;
      packages.enable = false;
      spicetify.enable = false;
      syncthing.enable = false;
      lan-mouse.enable = false;
    };
  };
}
