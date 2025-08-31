{ ... }:

{
  homebrew = {
    enable = true;
    taps = [
      "heroku/brew"
    ];
    brews = [
      "heroku/brew/heroku"
    ];
    casks = [
      "1password"
      "1password-cli"
      "discord"
      "docker"
      "ghostty"
      "google-chrome"
      "phpstorm"
      "postman"
      "pycharm"
      "raycast"
      "slack"
      "spotify"
      "sublime-text"
      "tableplus"
    ];
  };
}
