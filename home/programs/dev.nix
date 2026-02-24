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

        # PHP
        php
        php.packages.composer

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
      COMPOSER_HOME = "${config.home.homeDirectory}/.composer";
      POETRY_HOME = "${config.home.homeDirectory}/.poetry";
      POETRY_CACHE_DIR = "${config.home.homeDirectory}/.cache/poetry";
      PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.composer/vendor/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.poetry/bin"
      "${config.home.homeDirectory}/.pyenv/bin"
    ];

    # Pure write to files
    file = {
      ".composer/composer.json".text = builtins.toJSON {
        "require" = {
          "friendsofphp/php-cs-fixer" = "^3.75";
          "laravel/installer" = "^5.17";
          "laravel/pint" = "^1.22";
          "pestphp/pest" = "^3.8.2";
          "phpstan/phpstan" = "^2.1";
          "squizlabs/php_codesniffer" = "*";
          "statamic/cli" = "*";
          "wp-coding-standards/wpcs" = "^3.1";
        };
        "require-dev" = {
          "dealerdirect/phpcodesniffer-composer-installer" = "^1.0";
        };
        "config" = {
          "allow-plugins" = {
            "dealerdirect/phpcodesniffer-composer-installer" = true;
            "pestphp/pest-plugin" = true;
            "php-http/discovery" = true;
          };
        };
      };

    }
    // {

      ".php-cs-fixer.php".text = ''
        <?php
        return (new PhpCsFixer\Config())
            ->setRules([
                '@PSR12' => true,
                'array_syntax' => ['syntax' => 'short'],
                'ordered_imports' => ['sort_algorithm' => 'alpha'],
                'no_unused_imports' => true,
                'not_operator_with_successor_space' => true,
                'trailing_comma_in_multiline' => true,
                'phpdoc_scalar' => true,
                'unary_operator_spaces' => true,
                'binary_operator_spaces' => true,
                'blank_line_before_statement' => [
                    'statements' => ['break', 'continue', 'declare', 'return', 'throw', 'try'],
                ],
            ])
            ->setFinder(
                PhpCsFixer\Finder::create()
                    ->exclude('bootstrap/cache')
                    ->exclude('storage')
                    ->exclude('vendor')
                    ->in(__DIR__)
                    ->name('*.php')
                    ->notName('*.blade.php')
                    ->ignoreDotFiles(true)
                    ->ignoreVCS(true)
            );
      '';

      ".npmrc".text = ''
        cache=${config.home.homeDirectory}/.npm-cache
        tmp=${config.home.homeDirectory}/.npm-tmp
        init-author-name=Jon Erickson
        init-author-email=jon@deschutesdesigngroup.com
        init-license=MIT
        save-exact=true
      '';

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

    # Home manager activation scripts
    activation = {
      # Run composer global update after activation to ensure all packages are installed
      composerGlobalInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Running composer global update...."
        $DRY_RUN_CMD ${pkgs.php.packages.composer}/bin/composer global update --no-interaction || true
      '';
    };
  };
}
