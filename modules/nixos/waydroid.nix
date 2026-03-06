{
  lib,
  config,
  pkgs,
  ...
}:

let
  category = "sistema"; # [ sistema | home-manager ]
  moduleName = "waydroid";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {

    virtualisation.waydroid.enable = true;
    environment.systemPackages = with pkgs; [
      unstable.waydroid
      unstable.waydroid-helper
    ];

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
  };
}
