{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modulos.home-manager.java.enable = lib.mkEnableOption "java";

  config = lib.mkIf config.modulos.home-manager.java.enable {
    programs = {
      java = {
        enable = true;
        package = pkgs.zulu25.override {
          enableJavaFX = true;
        };
      };
    };
  };
}
