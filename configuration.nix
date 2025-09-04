{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/SysPakages.nix
    ./modules/system/users.nix
    ./modules/system/services.nix
    ./modules/system/zsh.nix
  ];

  # Configuración básica del sistema
  system.stateVersion = "25.05";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";
  nixpkgs.config.allowUnfree = true;
  #system.autoUpgrade.enable = true;

  # Red
  networking = {
    hostName = "NeoReaper";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation = {
    waydroid.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
  };

  system.activationScripts.copy-dotfiles = {
    text = ''
      echo ""
    '';
    deps = [ ];
  };
}
