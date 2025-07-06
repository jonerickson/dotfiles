{ config, pkgs, username, ... }:

{
  # Import other configuration modules
  imports = [
    ./programs/dev.nix
    ./programs/git.nix
    ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
  home.homeDirectory = "/Users/${username}";
  home.packages = with pkgs; [
    # Development tools
    git
    curl
    wget

    # System utilities
    htop
    tree
    jq
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nano";  # or your preferred editor
    BROWSER = "open";
  };

  # Dotfiles that don't have dedicated Home Manager options
  home.file = {
    # Example: if you have custom config files
    # ".config/some-app/config.toml".source = ./dotfiles/some-app-config.toml;

    # You can also use text content directly
    # ".config/example/config.txt".text = ''
    #   Some configuration content
    # '';
  };

  # XDG configuration (for apps that follow XDG standards)
  xdg = {
    enable = true;

    # Example XDG config files
    # configFile = {
    #   "app/config.yml".source = ./dotfiles/app-config.yml;
    # };
  };
}
