{
  config,
  pkgs,
  lib,
  ...
}:

{
  home = {
    packages = with pkgs; [
      # IDE
      jetbrains.phpstorm

      # PHP
      php
      php.packages.composer

      # Node
      nodejs_22
      nodePackages.yarn
      nodePackages.pnpm
      bun

      # Ruby
      ruby_3_3
      cocoapods

      # Python
      python3
      poetry
      pyenv
      python3Packages.black
      python3Packages.flake8
      python3Packages.pytest
      python3Packages.pip
      python3Packages.pipx
      python3Packages.virtualenv

      # Databases
      mysql80
      postgresql_15
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
      NVM_DIR = "${config.home.homeDirectory}/.nvm";
      PNPM_HOME = "${config.home.homeDirectory}/Library/pnpm";
      POETRY_HOME = "${config.home.homeDirectory}/.poetry";
      POETRY_CACHE_DIR = "${config.home.homeDirectory}/.cache/poetry";
      PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.composer/vendor/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.npm-global/bin"
      "${config.home.homeDirectory}/.poetry/bin"
      "${config.home.homeDirectory}/.pyenv/bin"
      "${config.home.homeDirectory}/Library/pnpm"
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

    } // lib.optionalAttrs (config.sops.secrets ? "composer/whizzy-username") {
      ".composer/auth.json.template" = {
        text = builtins.toJSON {
          http-basic = {
            "whizzy.dev" = {
              username = "@WHIZZY_USERNAME@";
              password = "@WHIZZY_PASSWORD@";
            };
            "filament-filter-sets.composer.sh" = {
              username = "@FILAMENT_USERNAME@";
              password = "@FILAMENT_PASSWORD@";
            };
            "spark.laravel.com" = {
              username = "@SPARK_USERNAME@";
              password = "@SPARK_PASSWORD@";
            };
          };
          github-oauth = {
            "github.com" = "@GITHUB_TOKEN@";
          };
        };
      };
    }
    // {

      ".nvm".source = pkgs.fetchFromGitHub {
        owner = "nvm-sh";
        repo = "nvm";
        rev = "v0.39.7";
        sha256 = "0zsd325zqscnxdmggclxbghzj7xpqlvi4vb8gfdf7pf5nk4c7ln2";
      };

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
        prefix=${config.home.homeDirectory}/.npm-global
      '';

      ".npm-global/package.json".text = builtins.toJSON {
        "name" = "global-packages";
        "version" = "1.0.0";
        "description" = "Global NPM packages";
        "dependencies" = {
          "@anthropic-ai/claude-code" = "^1.0.72";
          "@vue/cli" = "^5.0";
          "concurrently" = "^9.1";
          "create-react-app" = "^5.0";
          "cross-env" = "^7.0";
          "cypress" = "^14.5";
          "dotenv-cli" = "^7.4";
          "eslint" = "^9.18";
          "jest" = "^30.0";
          "mintlify" = "^4.2";
          "nodemon" = "^3.1";
          "npm-check-updates" = "^17.1";
          "playwright" = "^1.50";
          "pm2" = "^5.4";
          "prettier" = "^3.4";
          "serve" = "^14.2";
          "ts-node" = "^10.9";
          "typescript" = "^5.7";
          "vite" = "^6.0";
          "vitest" = "^2.1";
        };

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

    # Home manager activation scripts
    activation = {
      # Run composer global update after activation to ensure all packages are installed
      composerGlobalInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Running composer global update...."
        $DRY_RUN_CMD ${pkgs.php.packages.composer}/bin/composer global update --no-interaction || true
      '';

      # Install NPM global packages
      npmGlobalInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Running npm global install...."
        export PATH="${pkgs.nodejs_22}/bin:$PATH"
        $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.npm-global
        $DRY_RUN_CMD cd ${config.home.homeDirectory}/.npm-global && ${pkgs.nodejs_22}/bin/npm install --production --no-audit --no-fund --quiet || true
      '';
    } // lib.optionalAttrs (config.sops.secrets ? "composer/whizzy-username") {
      # Generate composer auth.json from template with secrets
      composerAuthGenerate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [[ -f "${config.home.homeDirectory}/.composer/auth.json.template" ]]; then
          echo "Generating composer auth.json from template..."
          $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.composer
          $DRY_RUN_CMD ${pkgs.gnused}/bin/sed \
            -e "s|@WHIZZY_USERNAME@|$(cat ${config.sops.secrets."composer/whizzy-username".path})|g" \
            -e "s|@WHIZZY_PASSWORD@|$(cat ${config.sops.secrets."composer/whizzy-password".path})|g" \
            -e "s|@FILAMENT_USERNAME@|$(cat ${config.sops.secrets."composer/filament-username".path})|g" \
            -e "s|@FILAMENT_PASSWORD@|$(cat ${config.sops.secrets."composer/filament-password".path})|g" \
            -e "s|@SPARK_USERNAME@|$(cat ${config.sops.secrets."composer/spark-username".path})|g" \
            -e "s|@SPARK_PASSWORD@|$(cat ${config.sops.secrets."composer/spark-password".path})|g" \
            -e "s|@GITHUB_TOKEN@|$(cat ${config.sops.secrets."composer/github-token".path})|g" \
            "${config.home.homeDirectory}/.composer/auth.json.template" > "${config.home.homeDirectory}/.composer/auth.json"
        fi
      '';
    };
  };
}
