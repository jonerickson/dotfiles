{
  config,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./programs/dev.nix
    ./programs/git.nix
    ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.05";
    homeDirectory = "/Users/${username}";

    packages = with pkgs; [
      # Development tools
      git
      curl
      wget

      # System utilities
      htop
      tree
      jq

      # Nix
      nixfmt-rfc-style
    ];

    sessionVariables = {
      EDITOR = "nano";
      BROWSER = "open";
    };
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
