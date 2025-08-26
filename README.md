# Dotfiles

Nix-based dotfiles configuration using Home Manager and nix-darwin for macOS system management.

## Prerequisites

### 1. Install Nix
Install the Nix package manager with flakes support:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

After installation, restart your terminal or source the environment:
```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 2. Enable Flakes (if not already enabled)
Add to your `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### 3. Clone Repository
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

## Installation

### First-time Setup
1. **Apply Home Manager Configuration**:
```bash
nix run .#homeConfigurations.jonerickson.activationPackage
```

2. **Apply System Configuration (Darwin)**:
```bash
nix build .#darwinConfigurations.jonerickson.system
sudo ./result/sw/bin/darwin-rebuild activate 
```

**Important**: Make sure all changes are committed before building: `git add -A && git commit -m "Initial setup"`

### Subsequent Updates
After making changes to the configuration:
```bash
git add -A
git commit -m "Update configuration"
nix build .#darwinConfigurations.jonerickson.system
sudo ./result/sw/bin/darwin-rebuild activate
```

## What's Included

### Development Tools
- **PHP**: PHP 8.4, Composer with Laravel, Pest, PHPStan, PHP CS Fixer
- **Node.js**: Node.js 22, npm, yarn, pnpm, Bun with global packages (ESLint, Prettier, TypeScript, Vite, etc.)
- **Python**: Python 3, pyenv, poetry, pip, pipx, virtualenv, black, flake8, pytest
- **Ruby**: Ruby 3.3, CocoaPods

### Databases & Storage
- **Databases**: MySQL 8.0, PostgreSQL 15, Redis, SQLite
- **GUI Tools**: DBeaver

### IDEs & Editors
- **IDEs**: PhpStorm (via Homebrew), nano, vim
- **Editor Configs**: EditorConfig, PHP CS Fixer, Pylint configuration

### Development Infrastructure
- **Containers**: Docker, Docker Compose
- **Build Tools**: GNU Make, CMake, pkg-config
- **Version Control**: Git with LFS, GitHub CLI, git-filter-repo
- **Web Tools**: curl, wget, HTTPie, Postman, mkcert, ngrok, chromedriver

### CLI Utilities
- **Search & Navigation**: ripgrep, fd, fzf, bat, tree
- **System**: htop, jq, yq
- **Archives**: unzip, p7zip
- **Media**: ImageMagick, FFmpeg
- **Network**: OpenSSH, rsync

### Shell & Environment
- **Shell**: Zsh with Oh My Zsh, syntax highlighting, autosuggestions
- **Themes & Plugins**: Robbyrussell theme, Git, Brew, macOS, Docker, npm, Composer, Laravel plugins
- **Package Management**: Nix with flakes support, nixfmt for code formatting

### macOS Applications (Homebrew Casks)
- **Productivity**: 1Password, Raycast, Slack, Discord
- **Development**: Docker, Google Chrome, Sublime Text
- **Terminal**: Ghostty

## Maintenance

### Update Dependencies
```bash
nix flake update
```

### Validate Configuration
```bash
nix flake check
```

### Code Formatting
```bash
nixfmt ./**/*.nix
```

## Structure

- `flake.nix` - Main configuration with inputs and outputs
- `home/` - Home Manager user configurations
- `modules/` - System-level modules
- `modules/darwin` - System-level modules specific for darwin OS
