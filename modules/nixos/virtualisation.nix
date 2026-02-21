{ ... }:
{
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
}
