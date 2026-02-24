{ config, lib, ... }:

let
  marketplaces = [
    "laravel/claude-code"
  ];
  plugins = [
    "context7@claude-plugins-official"
    "ralph-loop@claude-plugins-official"
    "typescript-lsp@claude-plugins-official"
    "frontend-design@claude-plugins-official"
    "laravel-boost@claude-plugins-official"
    "laravel-simplifier@laravel"
    "figma@claude-plugins-official"
    "atlassian@claude-plugins-official"
    "sentry@claude-plugins-official"
  ];
  marketplaceCmds = builtins.concatStringsSep "\n" (
    map (m: "claude plugin marketplace add ${m} 2>/dev/null || true") marketplaces
  );
  installCmds = builtins.concatStringsSep "\n" (
    map (p: "claude plugin install ${p} 2>/dev/null || true") plugins
  );
in
{
  home.activation.claudePlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v claude &> /dev/null; then
      ${marketplaceCmds}
      ${installCmds}
    fi
  '';
}
