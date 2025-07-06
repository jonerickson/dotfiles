{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Let Home Manager handle basic shell configuration
    shellAliases = {
      ll = "ls -lah";
      la = "ls -la";
      l = "ls -l";
      grep = "grep --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      art = "php artisan $@";
      code = "cd ~/Code";
    };

    # Source your existing .zshrc for complex integrations
    initExtra = ''
      # Source your existing .zshrc for tool-specific configurations
      if [[ -f "$HOME/.zshrc_original" ]]; then
        source "$HOME/.zshrc_original"
      fi

      # Additional Home Manager managed configuration
      # Custom functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # History configuration (enhanced)
      export HISTSIZE=10000
      export SAVEHIST=10000
      export HISTFILE="$HOME/.zsh_history"

      # Zsh options for better history
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt SHARE_HISTORY
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY
      setopt HIST_REDUCE_BLANKS
      setopt HIST_VERIFY
    '';

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "poetry"
        "git"
        "brew"
        "macos"
        "docker"
        "docker-compose"
        "npm"
        "yarn"
        "composer"
        "laravel"
        "symfony"
      ];
    };
  };

  home.file.".zshrc_original".source = ../dotfiles/zshrc;
}