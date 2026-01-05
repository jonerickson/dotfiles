{ config, username, ... }:

{
  # Required system settings
  system.stateVersion = 6;
  system.primaryUser = username;

  # Nix configuration - let Determinate manage the nix daemon
  nix.enable = false;

  # Install Homebrew
  nix-homebrew = {
    enable = true;
    user = username;
    enableRosetta = true; # Apple Silicon
    autoMigrate = true;
  };

  # macOS system preferences
  system.defaults = {
    dock = {
      autohide = false;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };
  };
}
