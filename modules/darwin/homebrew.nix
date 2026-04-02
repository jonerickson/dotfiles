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
      "aws/tap"
      "heroku/brew"
      "minio/stable"
      "pomerium/tap"
      "shivammathur/extensions"
      "shivammathur/php"
    ];
    brews = [
      "aws-iam-authenticator"
      "awscli"
      "doctl"
      "eksctl"
      "helm"
      "heroku/brew/heroku"
      "kubernetes-cli"
      "minio/stable/mc"
      "opentofu"
      "pomerium-cli"
      "shivammathur/extensions/grpc@8.5"
      "shivammathur/extensions/protobuf@8.5"
      "postgresql@18"
      "stripe-cli"
      "terraform"
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
