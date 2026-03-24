{
  lib,
  config,
  pkgs,
  ...
}:

let
  category = "sistema"; # [ sistema | home-manager ]
  moduleName = "servidor";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
    networking = {
      interfaces.enp3s0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.199";
            prefixLength = 24;
          }
        ];
      };
      defaultGateway = "192.168.1.1";
      nameservers = [
        "192.168.1.1"
        "8.8.8.8"
      ];
    };
    services = {
      auto-cpufreq = {
        enable = true;
        settings = {
          charger = {
            governor = "powersave";
            turbo = "never";
          };
        };
      };

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "";
          DISK_IDLE_SECS_ON_AC = 5;
          USB_AUTOSUSPEND = 1;
        };
      };
      power-profiles-daemon.enable = false;
      thermald.enable = true;
      openssh.enable = true;
      upower.enable = true;
      gnome.gnome-keyring.enable = true;
    };
    security.wrappers.beep = {
      owner = "root";
      group = "wheel";
      source = "${pkgs.beep}/bin/beep";
      permissions = "u+rs,g+rs,o+rx";
    };

    systemd.services.boot-beep = {
      description = "Beep when system is ready for SSH";
      after = [
        "multi-user.target"
        "network-online.target"
        "sshd.service"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = false;
      };
      script = ''
        sleep 3
        ${pkgs.beep}/bin/beep -f 1000 -l 200 -r 3 -D 100 2>/dev/null || true
      '';
    };
  };
}
