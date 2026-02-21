{ pkgs, ... }:
{
  services = {
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome.enable = true;
  };

  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
