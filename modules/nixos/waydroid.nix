{ ... }:
{
  virtualisation.waydroid.enable = true;
  
  users = {
    users.xardec = {
      extraGroups = [
        "waydroid"
      ];
    };
    users.waydroid-xardec = {
      isSystemUser = true;
      uid = 10121;
      group = "waydroid";
      home = "/var/empty";
      shell = "/run/current-system/sw/bin/nologin";
    };
    users.waydroid-root = {
      isSystemUser = true;
      uid = 1023;
      group = "waydroid";
      home = "/var/empty";
      shell = "/run/current-system/sw/bin/nologin";
    };
    groups.waydroid.gid = 1023;
  };
}
