{
  config,
  pkgs,
  lib,
  ...
}:

let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      cloud-sql-proxy
      gke-gcloud-auth-plugin
    ]
  );
in
{
  home = {
    packages =
      with pkgs;
      [
        # IDE
        jetbrains.phpstorm

        # Node
        bun

        # Ruby
        ruby_3_3
        cocoapods

        # Python
        poetry
        pyenv

        # Databases
        mysql80
        redis
        sqlite
        dbeaver-bin

        # Docker
        docker
        docker-compose

        # Tools
        gnumake
        cmake
        pkg-config
        ripgrep
        fd
        fzf
        bat
        curl
        wget
        httpie
        postman
        mkcert
        ngrok
      ]
      ++ [
        gdk

        # System
        jq
        yq
        htop
        tree

        # Zip
        unzip
        p7zip

        # Additional Dev Tools
        openssh
        rsync
        imagemagick
        ffmpeg

        # Browser Automation
        chromedriver

        # Text Editors
        nano
        vim
      ];

    sessionVariables = {
      POETRY_HOME = "${config.home.homeDirectory}/.poetry";
      POETRY_CACHE_DIR = "${config.home.homeDirectory}/.cache/poetry";
      PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.poetry/bin"
      "${config.home.homeDirectory}/.pyenv/bin"
    ];

    # Pure write to files
    file = {
      ".pylintrc".text = ''
        [MASTER]
        load-plugins=pylint.extensions.docparams

        [MESSAGES CONTROL]
        disable=C0114,C0116,R0903,W0613

        [FORMAT]
        max-line-length=88
        good-names=i,j,k,ex,Run,_,id,pk

        [DESIGN]
        max-args=7
        max-attributes=12
        max-public-methods=25
      '';

      ".poetry/config.toml".text = ''
        [virtualenvs]
        create = true
        in-project = true
        path = "{cache-dir}/virtualenvs"

        [repositories]

        [installer]
        parallel = true

        [cache]
        dir = "${config.home.homeDirectory}/.cache/poetry"
      '';

      ".editorconfig".text = ''
        root = true

        [*]
        charset = utf-8
        end_of_line = lf
        insert_final_newline = true
        indent_style = space
        indent_size = 4
        trim_trailing_whitespace = true

        [*.{js,jsx,ts,tsx,json,css,scss,vue}]
        indent_size = 2

        [*.{yml,yaml}]
        indent_size = 2

        [*.md]
        trim_trailing_whitespace = false
      '';
    };
  };
}
