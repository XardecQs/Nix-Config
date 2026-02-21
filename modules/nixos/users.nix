{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;
    users.root.shell = pkgs.zsh;
    users.xardec = {
      isNormalUser = true;
      description = "Xavier Del Piero";
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
      ];
    };
  };
  programs = {
    zsh.enable = true;
  };
}
