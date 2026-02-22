{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "uhci_hcd"
      "ehci_pci"
      "ata_piix"
      "usbhid"
      "usb_storage"
      "floppy"
      "sd_mod"
      "sr_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/aeec6a81-21d2-4cc3-adbe-00e5a35dce30";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "autodefrag"
      "space_cache=v2"
    ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/4E44-BCA0";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/aeec6a81-21d2-4cc3-adbe-00e5a35dce30";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "autodefrag"
      "space_cache=v2"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5cf9a76b-901f-4b07-aaee-3b2339536b04"; }
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 150;
    priority = 100;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
