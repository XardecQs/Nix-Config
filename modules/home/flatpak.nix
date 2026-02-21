{ ... }:
{
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
      ];
    };
  };
}
