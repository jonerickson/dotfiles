{ config, lib, pkgs, ... }:

let
  marketplaces = [
    "laravel/claude-code"
  ];
  plugins = [
    "context7@claude-plugins-official"
    "typescript-lsp@claude-plugins-official"
    "frontend-design@claude-plugins-official"
    "laravel-boost@claude-plugins-official"
    "laravel-simplifier@laravel"
    "atlassian@claude-plugins-official"
    "sentry@claude-plugins-official"
    "code-simplifier@claude-plugins-official"
    "code-review@claude-plugins-official"
    "github@claude-plugins-official"
    "feature-dev@claude-plugins-official"
  ];
  marketplaceCmds = builtins.concatStringsSep "\n" (
    map (m: ''$CLAUDE_BIN plugin marketplace add ${m} || echo "Warning: failed to add marketplace ${m}"'') marketplaces
  );
  installCmds = builtins.concatStringsSep "\n" (
    map (p: ''$CLAUDE_BIN plugin install ${p} || echo "Warning: failed to install plugin ${p}"'') plugins
  );
in
{
  home.activation.claudePlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
    CLAUDE_BIN="$HOME/.local/bin/claude"
    if [ -x "$CLAUDE_BIN" ]; then
      ${marketplaceCmds}
      ${installCmds}
    fi
  '';
}
