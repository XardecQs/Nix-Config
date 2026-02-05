{ pkgs, ... }:

{
  # Habilitar GTK y Qt para coherencia visual
  gtk = {
    enable = true;
    cursorTheme.name = "MacOS-Tahoe-Cursor";
    font.name = "SF Pro Display";
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
  };

  # GNOME Keyring (desbloqueo automático de contraseñas)
  services.gnome-keyring.enable = true;

  # Configuraciones dconf (preferencias de GNOME)
  dconf.settings = {
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };

    # Extensiones habilitadas
    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        dash-to-dock.extensionUuid
        show-desktop-button.extensionUuid
        user-themes.extensionUuid
        gsconnect.extensionUuid
        blur-my-shell.extensionUuid
        gtk4-desktop-icons-ng-ding.extensionUuid
        rounded-window-corners-reborn.extensionUuid
        clipboard-indicator.extensionUuid
        fullscreen-hot-corner.extensionUuid
        caffeine.extensionUuid
        tray-icons-reloaded.extensionUuid
        emoji-copy.extensionUuid
        logo-menu.extensionUuid
        auto-adwaita-colors.extensionUuid
        "MaximizeWindowIntoNewWorkspace@kyleross.com"

      ];
    };

    # Tema de shell (User Themes extension)
    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-blue-dark";
    };

    # Keybindings personalizados
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Kitty";
      command = "kitty";
      binding = "<Super>q";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Open Nautilus";
      command = "nautilus";
      binding = "<Super>e";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Wallpaper aleatorio";
      command = "/home/xardec/Proyectos/Scripts/sh/gnome-wallpaper.sh 'Imagen aleatoria'";
      binding = "<Super><Shift>w";
    };

    # Desactivar atajos de aplicaciones predeterminadas (para usar workspaces 1-9)
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };

    # Workspaces y cierre de ventanas
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
    };
  };
}
