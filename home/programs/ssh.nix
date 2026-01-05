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
    controlPath = "~/.ssh/master-%n-%r@%h:%p";
    controlPersist = "10m";

    # Config
    extraConfig = ''
      AddKeysToAgent yes
    '';

    # Hosts
    matchBlocks = {
      "gh-personal" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_rsa";
        identitiesOnly = true;
        port = 22;
      };

      "gh-leasecake" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_leasecake";
        identitiesOnly = true;
        port = 22;
      };
    };
  };
}
