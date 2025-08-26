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

    initContent = ''
      # Load Nix daemon environment (multi-user installation)
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi

      # Source custom zsh files
      if [[ -f "$HOME/.herd" ]]; then
        source "$HOME/.herd"
      fi

      # Initialize pyenv
      if command -v pyenv >/dev/null 2>&1; then
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
      fi

      # Load nvm
      if [ -n "$NVM_DIR" ]; then
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
      fi

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

  # Write custom zsh files
  home.file.".herd".source = ../dotfiles/herd.zsh;
}
