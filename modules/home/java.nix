{ pkgs, ... }:
{
  programs = {
    java = {
      enable = true;
      package = pkgs.zulu25.override {
        enableJavaFX = true;
      };
    };
  };
}