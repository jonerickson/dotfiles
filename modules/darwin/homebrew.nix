{ username, ... }:

let
  trustedTaps = [
    "aws/tap"
    "heroku/brew"
    "minio/stable"
    "pomerium/tap"
    "shivammathur/extensions"
    "shivammathur/php"
  ];
in
{
  # Non-official taps must be trusted before Homebrew loads their formulae;
  # the check is on by default and raises rather than prompts. Activation runs
  # brew under `sudo --user`, which leaves SUDO_USER=root and drops
  # XDG_CONFIG_HOME, so brew resolves its trust store against root's home and
  # the `~/.homebrew` fallback. Seed every candidate path.
  system.activationScripts.preActivation.text = ''
        for configHome in \
          /var/root/.homebrew \
          /var/root/.config/homebrew \
          /Users/${username}/.homebrew \
          /Users/${username}/.config/homebrew
        do
          mkdir -p "$configHome"
          cat > "$configHome/trust.json" <<'TRUSTJSON'
    ${builtins.toJSON { trustedtaps = trustedTaps; }}
    TRUSTJSON
          chmod 600 "$configHome/trust.json"
        done
        chown -R ${username} /Users/${username}/.homebrew /Users/${username}/.config/homebrew
  '';

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
      "shivammathur/extensions/pcov@8.5"
      "postgresql@18"
      "qpdf"
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
