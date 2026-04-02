{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      php
      php.packages.composer
    ];

    sessionVariables = {
      COMPOSER_HOME = "${config.home.homeDirectory}/.composer";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.composer/vendor/bin"
    ];

    file = {
      ".composer/composer.json".text = builtins.toJSON {
        "require" = {
          "friendsofphp/php-cs-fixer" = "*";
          "laravel/installer" = "*";
          "laravel/pint" = "*";
          "pestphp/pest" = "*";
          "phpstan/phpstan" = "*";
          "squizlabs/php_codesniffer" = "*";
          "statamic/cli" = "*";
          "wp-coding-standards/wpcs" = "*";
        };
        "require-dev" = {
          "dealerdirect/phpcodesniffer-composer-installer" = "*";
        };
        "config" = {
          "allow-plugins" = {
            "dealerdirect/phpcodesniffer-composer-installer" = true;
            "pestphp/pest-plugin" = true;
            "php-http/discovery" = true;
          };
        };
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
    };

    activation.composerGlobalInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Running composer global update...."
      $DRY_RUN_CMD ${pkgs.php.packages.composer}/bin/composer global update --no-interaction || true
    '';
  };
}
