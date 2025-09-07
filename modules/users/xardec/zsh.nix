{
  config,
  pkgs,
  dotfilesDir,
  ...
}:

{
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
