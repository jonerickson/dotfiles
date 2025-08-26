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
    ./programs/ssh.nix
    ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
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
  };
}
