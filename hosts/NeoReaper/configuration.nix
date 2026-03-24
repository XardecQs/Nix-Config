{ pkgs, ... }:
{
  networking.hostName = "NeoReaper";

  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  modulos = {
    sistema = {
      escritorio = {
        gnome.enable = true;
        sway.enable = false;
      };
      boot.enable = true;
      general.enable = true;
      intel-gpu.enable = true;
      laptop.enable = true;
      locate.enable = true;
      networking.enable = true;
      nix.enable = true;
      #steam.enable = true;
      systemPackages.enable = true;
      users.enable = true;
      #virtualisation.enable = true;
      #waydroid.enable = true;
      pipewire.enable = true;
      security.enable = true;
    };
  };

  #/--------------------/ Servicios principales /--------------------/#
  services = {
    flatpak.enable = true;
    sshd.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "latam";
      videoDrivers = [ "intel" ];
    };

    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    allowTrash = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/var/db/sudo"
    ];
    files = [
      "/etc/machine-id"
      "/var/cache/locatedb"
    ];
    users.xardec = {
      directories = [
        ".cache/clipboard-indicator@tudmotu.com"
        ".config/Code"
        ".config/dconf"
        ".config/gsconnect"
        ".config/gtk-3.0"
        ".config/retroarch"
        ".dotfiles"
        ".local/share/ElyPrismLauncher"
        ".local/share/flatpak"
        #".local/share/Trash"
        ".local/share/fonts"
        ".local/share/zinit"
        ".local/state/zsh"
        ".ssh"
        ".var"
        ".vscode"
        "Descargas"
        "Documentos"
        "Media"
      ];
    };
  };
}
