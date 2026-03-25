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

    # ===== 1. RED Y FIREWALL =====
    networking = {
      interfaces.enp3s0.ipv4.addresses = [
        {
          address = "192.168.1.199";
          prefixLength = 24;
        }
      ];
      defaultGateway = "192.168.1.1";
      nameservers = [
        "192.168.1.1"
        "8.8.8.8"
      ];

      firewall = {
        enable = true;
        allowedTCPPorts = [
          22 # SSH
          445 # Samba SMB
          139 # Samba NetBIOS
          5212 # Cloudreve
        ];
        allowedUDPPorts = [
          137
          138 # Samba Discovery
          5353 # mDNS (Avahi)
        ];
      };
    };

    # ===== 2. GESTIÓN DE ENERGÍA Y DISCO =====
    services = {
      auto-cpufreq = {
        enable = true;
        settings.charger = {
          governor = "powersave";
          turbo = "never";
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

      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
      };
    };

    # ===== 3. ACCESO Y DESCUBRIMIENTO (SSH, Samba, Avahi) =====
    services = {
      openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
      };

      # Descubrimiento para que el PC aparezca por nombre en la red
      avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      # Protocolo para que Windows vea el servidor fácilmente
      samba-wsdd.enable = true;

      # Servidor de Archivos
      samba = {
        enable = true;
        openFirewall = false;
        settings = {
          global = {
            security = "user";
            workgroup = "WORKGROUP";
            "server string" = "Servidor NixOS";
            "map to guest" = "never";
          };
          archivos = {
            path = "/srv/archivos";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
            "valid users" = "@users";
          };
        };
      };
    };

    # ===== 4. VIRTUALIZACIÓN (Podman + Cloudreve) =====
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune.enable = true;
        autoPrune.dates = "weekly";
      };

      oci-containers.backend = "podman";
      oci-containers.containers = {
        aria2 = {
          image = "p3terx/aria2-pro:latest";
          volumes = [
            "/srv/cloudreve/uploads:/data:rw"
            "/srv/aria2/config:/config:rw"
          ];
          environment = {
            PUID = "0";
            PGID = "0";
            UMASK_SET = "022";
            RPC_SECRET = "cloudreve-aria2-secret";
          };
          extraOptions = [ "--network=host" ];
          autoStart = true;
        };

        cloudreve = {
          image = "cloudreve/cloudreve:latest";
          volumes = [
            "/srv/cloudreve/uploads:/cloudreve/uploads:rw"
            "/srv/cloudreve/conf:/cloudreve/conf:rw"
            "/srv/cloudreve/db:/cloudreve/conf/db:rw"
            "/srv/cloudreve/avatar:/cloudreve/conf/avatar:rw"
          ];
          dependsOn = [ "aria2" ];
          extraOptions = [ "--network=host" ];
          autoStart = true;
        };
      };
    };

    # ===== 5. PAQUETES Y UTILIDADES =====
    environment.systemPackages = with pkgs; [
      htop
      powertop
      git
      vim
      pciutils
    ];

    # ===== 6. DIRECTORIOS =====
    systemd.tmpfiles.rules = [
      "d /srv/archivos 0755 root users -"
      "d /srv/config 0755 root users -"
      "d /srv/cloudreve 0755 root users -"
      "d /srv/cloudreve/uploads 0755 root users -"
      "d /srv/cloudreve/conf 0755 root users -"
      "d /srv/cloudreve/db 0755 root users -"
      "d /srv/cloudreve/avatar 0755 root users -"
      "d /srv/aria2 0755 root users -"
      "d /srv/aria2/config 0755 root users -"
    ];

    # ===== 7. BEEP DE ARRANQUE =====
    security.wrappers.beep = {
      owner = "root";
      group = "wheel";
      source = "${pkgs.beep}/bin/beep";
      permissions = "u+rs,g+rs,o+rx";
    };

    systemd.services.boot-beep = {
      description = "Beep when system is ready";
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

    # ===== BOTÓN DE ENCENDIDO PARA APAGADO GRACEFUL =====
    services.logind.settings = {
      Login = {
        # Presión corta del botón de poder = apagado seguro
        HandlePowerKey = "poweroff";
        # Presión larga (5s) = forzoso (último recurso)
        PowerKeyIgnoreInhibited = "yes";
      };
    };
  };
}
