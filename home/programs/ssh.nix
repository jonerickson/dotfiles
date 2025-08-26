{
  config,
  pkgs,
  ...
}:

{
  programs.ssh = {
    enable = true;

    # Client
    compression = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/master-%r@%h:%p";
    controlPersist = "10m";

    # Config
    extraConfig = ''
      AddKeysToAgent yes
      IdentitiesOnly yes
    '';

    # Hosts
    matchBlocks = {
      "github" = {
        hostname = "github.com";
        user = "jonerickson";
        identityFile = "~/.ssh/id_rsa";
        port = 22;
      };

      "github-bkjg" = {
        hostname = "github.com";
        user = "jonericksonbkjg";
        identityFile = "~/.ssh/id_rsa";
        port = 22;
      };
    };
  };
}
