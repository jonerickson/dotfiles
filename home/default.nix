{
  config,
  pkgs,
  lib,
  username,
  ...
}:

{
  imports = [
    ./programs/dev.nix
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

  # sops-nix configuration
  sops = lib.mkIf (builtins.pathExists ./secrets.yaml) {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "composer/whizzy-username" = { };
      "composer/whizzy-password" = { };
      "composer/filament-username" = { };
      "composer/filament-password" = { };
      "composer/spark-username" = { };
      "composer/spark-password" = { };
      "composer/github-token" = { };
    };
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
      # Nix
      nixfmt-rfc-style

      # Secrets management
      sops
      age
    ];

    sessionVariables = {
      EDITOR = "nano";
      BROWSER = "open";
    };
  };

  # XDG configuration (for apps that follow XDG standards)
  xdg = {
    enable = true;
  };
}
