{ config, pkgs, ... }:

{
  # Import other configuration modules
  imports = [
    ./programs/zsh.nix
    # Add other program configurations here as you create them
    # ./programs/git.nix
    # ./programs/tmux.nix
    # ./programs/neovim.nix
  ];

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

  # Basic packages you want installed
  home.packages = with pkgs; [
    # Development tools
    git
    curl
    wget
    
    # System utilities
    htop
    tree
    jq
    
    # Add your preferred packages here
    # pkgs.unstable.some-newer-package  # Access unstable packages like this
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