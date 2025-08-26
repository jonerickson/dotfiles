{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    git-lfs
    gh
    git-filter-repo
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Jon Erickson";
    userEmail = "jon@deschutesdesigngroup.com";

    aliases = {
      gcm = "checkout master";
      gcs = "checkout staging";
      gcd = "checkout develop";
      grd = "rebase origin/develop";
    };

    extraConfig = {
      diff.colorMoved = "default";
      init.defaultBranch = "master";
      pull.rebase = true;
      push.default = "simple";
    };

    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      # Editor files
      "*~"
      "*.swp"
      "*.swo"
      ".vscode/"
      ".idea/"
      "*.sublime-project"
      "*.sublime-workspace"

      # OS generated files
      "Thumbs.db"
      "ehthumbs.db"
      "Desktop.ini"

      # Node.js
      "node_modules/"
      "npm-debug.log*"
      "yarn-debug.log*"
      "yarn-error.log*"
      ".npm"
      ".node_repl_history"

      # Python
      "__pycache__/"
      "*.py[cod]"
      "*$py.class"
      "*.so"
      ".Python"
      "build/"
      "develop-eggs/"
      "dist/"
      "downloads/"
      "eggs/"
      ".eggs/"

      # PHP
      "vendor/"
      ".env"
      ".env.local"
      ".env.*.local"

      # Laravel
      "storage/framework/cache/"
      "storage/framework/sessions/"
      "storage/framework/views/"
      "storage/logs/"
      "bootstrap/cache/"

      # Logs
      "*.log"
      "logs/"

      # Temporary files
      "*.tmp"
      "*.temp"
      ".cache/"

      # Backup files
      "*.bak"
      "*.backup"
      "*.orig"
    ];
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.gitProtocol = "ssh";
  };
}