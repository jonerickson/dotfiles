{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    jetbrains.phpstorm

    nodejs_22
    nodePackages.typescript
    nodePackages.ts-node
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.nodemon
    nodePackages.yarn
    nodePackages.pnpm

    ruby_3_3
    cocoapods

    python3
    poetry
    pyenv

    mysql80
    postgresql_15
    redis
    sqlite
    dbeaver-bin

    curl
    wget
    jq
    yq
    httpie
    postman

    docker
    docker-compose

    wp-cli

    gnumake
    cmake
    pkg-config

    ripgrep
    fd
    fzf
    bat

    htop
    tree

    unzip
    p7zip
  ];

  home.sessionVariables = {
    POETRY_HOME = "${config.home.homeDirectory}/.poetry";
    POETRY_CACHE_DIR = "${config.home.homeDirectory}/.cache/poetry";
    PATH = lib.strings.concatStringsSep ":" [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.poetry/bin"
      "${config.home.homeDirectory}/.npm-global/bin"
    ];
  };

  home.file.".nvm".source = pkgs.fetchFromGitHub {
    owner = "nvm-sh";
    repo = "nvm";
    rev = "v0.39.7";
    sha256 = "0zsd325zqscnxdmggclxbghzj7xpqlvi4vb8gfdf7pf5nk4c7ln2";
  };

  home.file = {
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
}
