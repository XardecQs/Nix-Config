{ lib, config, ... }:
{
  options.modulos.home-manager.flatpak.enable = lib.mkEnableOption "flatpak";

  config = lib.mkIf config.modulos.home-manager.flatpak.enable {
    services = {
      flatpak = {
        enable = true;
        packages = [
          "com.github.tchx84.Flatseal"
          "com.github.johnfactotum.Foliate"
          "app.zen_browser.zen"
          "md.obsidian.Obsidian"
          "net.blockbench.Blockbench"
          "io.gitlab.adhami3310.Converter"
          "org.nickvision.tubeconverter"
          "org.kde.kdenlive"
          "com.github.neithern.g4music"
          "com.rtosta.zapzap"
          "org.onlyoffice.desktopeditors"
          "it.mijorus.gearlever"
          "io.github.Querz.mcaselector"
          "com.usebottles.bottles"
        ];
      };
    };
  };
}
