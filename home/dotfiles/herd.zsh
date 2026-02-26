# Herd injected PHP binary.
if [ -d "/Users/jonerickson/Library/Application Support/Herd/bin" ]; then
  export PATH="/Users/jonerickson/Library/Application Support/Herd/bin/":$PATH
fi

# Herd injected PHP 8.1 configuration.
export HERD_PHP_81_INI_SCAN_DIR="/Users/jonerickson/Library/Application Support/Herd/config/php/81/"

# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/jonerickson/Library/Application Support/Herd/config/php/82/"

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/jonerickson/Library/Application Support/Herd/config/php/83/"

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/jonerickson/Library/Application Support/Herd/config/php/84/"

# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="/Users/jonerickson/Library/Application Support/Herd/config/php/85/"
