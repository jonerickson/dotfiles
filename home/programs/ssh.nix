{
  config,
  pkgs,
  ...
}:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      # Hosts
      "gh-personal" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_rsa";
        IdentitiesOnly = true;
        Port = 22;
      };

      "gh-leasecake" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_leasecake";
        IdentitiesOnly = true;
        Port = 22;
      };

      # Client
      "*" = {
        AddKeysToAgent = "yes";
        Compression = true;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%n-%r@%h:%p";
        ControlPersist = "10m";

        # Previously implicit Home Manager defaults
        ForwardAgent = false;
        HashKnownHosts = false;
        ServerAliveCountMax = 3;
        ServerAliveInterval = 0;
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };
    };
  };
}
