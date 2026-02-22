{ lib, config, ... }:
{
  options.modulos.sistema.intel-gpu.enable = lib.mkEnableOption "intel-gpu";

  config = lib.mkIf config.modulos.sistema.intel-gpu.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
  };
}
