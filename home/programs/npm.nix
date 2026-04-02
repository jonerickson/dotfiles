{ config, lib, ... }:

let
  npmGlobalPackages = [
    "happy-coder"
    "opencode-ai"
    "workos"
  ];
in
{
  home = {
    file.".npmrc".text = ''
      cache=${config.home.homeDirectory}/.npm-cache
      tmp=${config.home.homeDirectory}/.npm-tmp
      init-author-name=Jon Erickson
      init-author-email=jon@deschutesdesigngroup.com
      init-license=MIT
      save-exact=true
    '';

    activation.npmGlobalInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      NVM_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
      NVM_DEFAULT=$(cat "$NVM_DIR/alias/default" 2>/dev/null)
      NODE_DIR=$(ls -d "$NVM_DIR/versions/node/v$NVM_DEFAULT"* 2>/dev/null | head -1)
      NPM_BIN="$NODE_DIR/bin/npm"

      export PATH="$NODE_DIR/bin:$PATH"
      if [ -x "$NPM_BIN" ] && [ ${builtins.toString (builtins.length npmGlobalPackages)} -gt 0 ]; then
        echo "Running npm global install..."
        $DRY_RUN_CMD "$NPM_BIN" i -g ${lib.concatStringsSep " " npmGlobalPackages} || true
      fi
    '';
  };
}
