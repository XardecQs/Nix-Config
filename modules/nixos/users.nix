{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modulos.sistema.users.enable = lib.mkEnableOption "users";

  config = lib.mkIf config.modulos.sistema.users.enable {
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
  };
}
