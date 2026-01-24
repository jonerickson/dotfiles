{ config, lib, ... }:

{
  home.file = {
    ".claude/skills" = {
      source = ../claude/skills;
      recursive = true;
    };
  };

  # Copy settings.json instead of symlinking so it can be modified by the user
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.claude
    if [ ! -f $HOME/.claude/settings.json ]; then
      cp ${../claude/settings.json} $HOME/.claude/settings.json
      chmod 644 $HOME/.claude/settings.json
    fi
  '';
}