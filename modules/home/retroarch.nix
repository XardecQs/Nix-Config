{
  lib,
  config,
  pkgs,
  ...
}:

let
  category = "home-manager"; # [ sistema | home-manager ]
  moduleName = "retroarch";
in
{
  options.modulos.${category}.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modulos.${category}.${moduleName}.enable {
    programs.retroarch.enable = true;
    home.packages = with pkgs.libretro; [
      mgba
      neocd
      snes9x
      pcsx2
      dolphin
      ppsspp
      swanstation
    ];
    home.file.".config/retroarch/cores" = {
      source = "${config.home.path}/lib/retroarch/cores";
    };
  };
}
