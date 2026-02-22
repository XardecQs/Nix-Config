{ lib, config, ... }:
{
  options.modulos.sistema.virtualisation.enable = lib.mkEnableOption "virtualisation";

  config = lib.mkIf config.modulos.sistema.virtualisation.enable {
    virtualisation = {
      libvirtd.enable = true;
      docker.enable = true;
    };

    users = {
      users.xardec = {
        extraGroups = [
          "docker"
          "libvirtd"
        ];
      };
    };
  };
}
