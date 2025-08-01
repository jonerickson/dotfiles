# Dotfiles

Nix-based dotfiles configuration using Home Manager and nix-darwin for macOS system management.

## Quick Start

### Apply Home Manager Configuration
```bash
home-manager switch --flake .#jonerickson
```

### Apply System Configuration (Darwin)
```bash
darwin-rebuild switch --flake .#jonerickson
```

## What's Included

- **Development Tools**: PHP, Node.js, Python, Ruby with package managers
- **Databases**: MySQL, PostgreSQL, Redis, SQLite with GUI tools  
- **CLI Utilities**: ripgrep, fd, fzf, bat, htop, and more
- **Git Configuration**: Aliases, global gitignore, GitHub CLI
- **Shell Setup**: Zsh with Oh My Zsh, syntax highlighting, autosuggestions
- **Editor Configs**: EditorConfig, PHP CS Fixer, Pylint, ESLint/Prettier

## Maintenance

### Update Dependencies
```bash
nix flake update
```

### Validate Configuration
```bash
nix flake check
```

## Structure

- `flake.nix` - Main configuration with inputs and outputs
- `home/` - Home Manager user configurations
- `modules/` - System-level darwin modules
