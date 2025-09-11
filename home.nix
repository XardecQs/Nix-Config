{
  config,
  pkgs,
  lib,
  dotfilesDir,
  zen-browser,
  spicetify-nix,
  ...
}:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in

{

  #/----------/ general /----------/#

  nixpkgs.config.allowUnfree = true;

  #imports = [
  #  ./modules/users/xardec/packages.nix
  #  ./modules/users/xardec/zsh.nix
  #  ./modules/users/xardec/gnome.nix
  #  ./modules/users/xardec/files.nix
  #];

  home = {
    stateVersion = "25.05";
    username = "xardec";
    homeDirectory = "/home/xardec";
  };

  #/----------/ archivos /----------/#

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/nvim";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/kitty";
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/fastfetch";
    ".vscode".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/vscode";
    ".icons".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/icons";
    #".local/share/fonts".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/fonts";
    ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/zsh";
    ".config/user-dirs.dirs".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/user-dirs.dirs";
  };

  #/----------/ gnome /----------/#

  services.gnome-keyring.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Definitivo";
    };
    cursorTheme = {
      name = "MacOS-Tahoe-Cursor";
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-blue-dark";
    };

    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        "MaximizeToEmptyWorkspace-extension@kovari.cc"
        "dash-to-dock@micxgx.gmail.com"
        "show-desktop-button@amivaleo"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "blur-my-shell@aunetx"
        "gtk4-ding@smedius.gitlab.com"
        "rounded-window-corners@fxgn"
        "clipboard-indicator@tudmotu.com"
        "fullscreen-hot-corner@sorrow.about.alice.pm.me"
        "caffeine@patapon.info"
        "trayIconsReloaded@selfmade.pl"
        "emoji-copy@felipeftn"
        "logomenu@aryan_k"
      ];
    };

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
      name = "walpaper aleatorio";
      command = "/home/xardec/Proyectos/Scripts/sh/gnome-wallpaper.sh 'Imagen aleatoria'";
      binding = "<Super><Shift>w";
    };

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

  #/----------/ paquetes /----------/#

  home.packages = with pkgs; [
    # CLI tools
    bat
    btop
    eza
    fastfetch
    fzf
    lsd
    zoxide
    ripgrep
    fd
    unzip
    wl-clipboard
    unimatrix
    tmux
    dpkg
    tree
    zsh-powerlevel10k
    jp2a
    libicns

    # Desktop environment tools
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.gsconnect
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.maximize-to-empty-workspace-2025
    gnomeExtensions.fullscreen-hot-corner
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.emoji-copy
    gnomeExtensions.logo-menu

    dconf-editor
    kitty
    github-desktop
    adw-gtk3
    switcheroo
    zenity
    ffmpegthumbnailer
    jellyfin-ffmpeg
    vlc
    menulibre

    # Multimedia and design
    krita
    inkscape
    firefox

    # Themes
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    marble-shell-theme
    adwaita-qt6

    # Development tools
    nodejs
    python3

    # Nix management
    home-manager

    # Printer drivers
    epson-escpr2

    # Containerization
    podman
    distrobox

    # Development and utilities
    vscode
    gthumb
    nixfmt-rfc-style
    texliveFull
    onlyoffice-desktopeditors

    # Gaming and emulation
    wineWowPackages.stagingFull
    winetricks
    steam
    lutris
    mangohud
    protonup
    prismlauncher
    mcaselector

    # Virtualization
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    freerdp
    qemu
    libvirt
    swtpm

    # AI and image processing
    realcugan-ncnn-vulkan
    realesrgan-ncnn-vulkan

    # Media
    youtube-music
    #spotify

    # Miscellaneous
    icoextract
    android-tools
    alsa-utils
    syncthing
    zapzap
    discord
    telegram-desktop
    blender
    waydroid
    rustup
    glibc.static
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.obs-pipewire-audio-capture
    upx
    arduino
    gnome-network-displays
    hydralauncher

    (zen-browser.packages."${pkgs.system}".default)
  ];

  services.syncthing = {
    enable = true;
    settings = {
      options = {
        urAccepted = -1;
      };
    };
  };

  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      fullAppDisplay
      beautifulLyrics
      shuffle
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      marketplace
      betterLibrary
    ];
  };

  #/----------/ zsh /----------/#

  programs.zsh = {

    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
      # source ${dotfilesDir}/zshrc

      autoload -U select-word-style
      select-word-style bash

      eval "$(fzf --zsh)" 
      eval "$(zoxide init --cmd cd zsh)"

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always $realpath'
      zstyle ':fzf-tab:*' fzf-flags --height=55% --border

      #/--------------------/ atajos de teclado /--------------------/#

      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
      bindkey "^[[3~" delete-char

      [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh
    '';

    shellAliases = {
      lla = "lsd -la";
      la = "lsd -a";
      ll = "lsd -l";
      ls = "lsd";
      q = "exit";
      c = "clear";
      ".." = "cd ..";
      "..." = "cd ../..";
      cf = "clear && fastfetch";
      cff = "clear && fastfetch --config /etc/nixos/modules/users/xardec/dotfiles/config/fastfetch/13-custom.jsonc";
      snvim = "sudo nvim";
      ordenar = "~/Proyectos/Scripts/sh/ordenar.sh";
      desordenar = "~/Proyectos/Scripts/sh/desordenar.sh";
      cp = "cp --reflink=auto";
      umatrix = "unimatrix -s 95 -f";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      syu = "yay -Syu";
      codepwd = ''code "$(pwd)"'';
      napwd = ''nautilus "$(pwd)" &> /dev/null & disown'';
      dots = "cd ~/.dotfiles && codepwd && q";
      dotsn = "cd ~/.dotfiles && nvim";
    };

    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions.outPath;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting.outPath;
      }
    ];
  };

}
