{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "heroku/brew"
    ];
    brews = [
      "aws-iam-authenticator"
      "awscli"
      "doctl"
      "eksctl"
      "helm"
      "heroku/brew/heroku"
      "kubernetes-cli"
      "postgresql@14"
      "stripe-cli"
    ];
    casks = [
      "1password"
      "1password-cli"
      "discord"
      "docker-desktop"
      "ghostty"
      "headlamp"
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
