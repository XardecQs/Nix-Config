{
  lib,
  config,
  pkgs,
  ...
}:

let
  category = "sistema";
  moduleName = "servidor";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {

    # ===== RED (Configuración Básica e IP Estática) =====
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
      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 ];
      };
    };

    # ===== GESTIÓN DE ENERGÍA (Optimizado para Servidor) =====
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
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          DISK_IDLE_SECS_ON_AC = 60;
          USB_AUTOSUSPEND = 1;
        };
      };

      power-profiles-daemon.enable = false;
      thermald.enable = true;
      upower.enable = true;

      # ===== ACCESO REMOTO SEGURO =====
      openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          #PasswordAuthentication = true;
        };
      };

      # ===== MANTENIMIENTO BTRFS =====
      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
      };
    };

    # ===== CONTENEDORES (Motor Minimalista) =====
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    # ===== UTILIDADES DE SISTEMA =====
    environment.systemPackages = with pkgs; [
      htop # Monitor de recursos
      powertop # Monitor de energía
      git # Para tus configs
      vim # Editor básico
      pciutils # lspci y herramientas de hardware
    ];

    # ===== ESTRUCTURA DE DIRECTORIOS BASE =====
    systemd.tmpfiles.rules = [
      "d /srv/archivos 0755 root users -"
      "d /srv/config 0755 root users -"
    ];

    # ===== AVISO DE ARRANQUE (Beep) =====
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
