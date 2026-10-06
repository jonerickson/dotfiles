{
  config,
  pkgs,
  lib,
  ...
}:

let
  pythonGlobalPackages = [
    "openpyxl"
  ];
in
{
  home = {
    activation.pythonGlobalInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PYENV_ROOT="${config.home.homeDirectory}/.pyenv"
      PYTHON_PREFIX=$(${pkgs.pyenv}/bin/pyenv prefix 2>/dev/null | cut -d: -f1)
      PYTHON_BIN="$PYTHON_PREFIX/bin/python"

      # Only install into pyenv-managed versions, never the system Python
      if [[ "$PYTHON_PREFIX" == "$PYENV_ROOT/versions/"* ]] && [ -x "$PYTHON_BIN" ] && [ ${builtins.toString (builtins.length pythonGlobalPackages)} -gt 0 ]; then
        echo "Running pip install for $(basename "$PYTHON_PREFIX")..."
        $DRY_RUN_CMD "$PYTHON_BIN" -m pip install --upgrade --disable-pip-version-check ${lib.concatStringsSep " " pythonGlobalPackages} || true
      fi
    '';
  };
}
