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
    device = "/dev/disk/by-uuid/6de86424-3a1a-4c5f-aac5-69956f87c299";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "autodefrag"
      "space_cache=v2"
    ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/416C-9D95";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/6de86424-3a1a-4c5f-aac5-69956f87c299";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "autodefrag"
      "space_cache=v2"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/dd7388ba-9e93-41d9-807c-c56b99300eff"; }
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
