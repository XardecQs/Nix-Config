{
  config,
  pkgs,
  spicetify-nix,
  ...
}:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        save = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      shellAliases = {
        lla = "lsd -la";
        la = "lsd -a";
        ll = "lsd -l";
        l1 = "lsd -1";
        ls = "lsd";
        q = "exit";
        c = "clear";
        ".." = "cd ..";
        "..." = "cd ../..";
        cf = "clear && fastfetch";
        cff = "clear && fastfetch --config /home/xardec/.dotfiles/config/fastfetch/13-custom.jsonc";
        snvim = "sudo nvim";
        cp = "cp --reflink=auto";
        umatrix = "unimatrix -s 95 -f";
        grep = "grep --color=auto";
        diff = "diff --color=auto";
        ordenar = "~/Proyectos/Scripts/sh/ordenar.sh";
        desordenar = "~/Proyectos/Scripts/sh/desordenar.sh";
        codepwd = ''code "$(pwd)"'';
        napwd = ''nautilus "$(pwd)" &> /dev/null & disown'';
      };

      initContent = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
        source <(fzf --zsh)
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(direnv hook zsh)"

        autoload -U select-word-style
        select-word-style bash

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.lsd}/bin/lsd --color=always $realpath'
        zstyle ':fzf-tab:*' fzf-flags --height=55% --border

        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
        bindkey '^H' backward-kill-word
        bindkey "^[[3~" delete-char

        export EDITOR=nvim
        export PATH="$PATH:$HOME/.local/bin"

        [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh

        if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
          exec tmux new-session -A
        fi
      '';
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        droidcam-obs
      ];
    };

    spicetify = {
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
  };
}
