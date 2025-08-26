# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix-based dotfiles repository using Home Manager and nix-darwin for macOS system configuration. It provides declarative configuration management for development tools, applications, and system settings.

## Key Commands

### Apply Home Manager Configuration
```bash
nix run .#homeConfigurations.jonerickson.activationPackage
```

### Apply Darwin (System) Configuration
```bash
nix build .#darwinConfigurations.jonerickson.system
sudo ./result/sw/bin/darwin-rebuild activate
```

### Update Flake Inputs
```bash
nix flake update
```

### Check Flake Configuration
```bash
nix flake check
```

## Architecture

### Core Structure
- `flake.nix` - Main flake configuration defining inputs and outputs
- `home/` - Home Manager configuration modules
- `modules/` - System-level modules for darwin configuration

### Configuration Layers
1. **System Level** (`darwinConfigurations`): Manages macOS system settings, Homebrew casks, and global configurations
2. **User Level** (`homeConfigurations`): Manages user-specific packages, dotfiles, and application configurations

### Key Configuration Files
- `home/default.nix` - Main home configuration entry point
- `home/programs/dev.nix` - Development tools and programming language setups
- `home/programs/git.nix` - Git configuration and related tools
- `home/programs/zsh.nix` - Shell configuration with Oh My Zsh
- `modules/home-manager.nix` - Home Manager module configuration

### Package Management
- **Nix packages**: Declaratively managed in `.nix` files
- **Homebrew casks**: GUI applications managed through nix-darwin
- **Language-specific packages**: Managed through respective package managers (npm, composer, poetry)

### Development Environment
The configuration includes comprehensive development tooling:
- **Languages**: PHP, Node.js, Python, Ruby
- **Databases**: MySQL, PostgreSQL, Redis, SQLite
- **Tools**: Docker, wp-cli, various CLI utilities
- **Editors**: PhpStorm (via Nix), with support for VS Code and other editors

### Secrets Management
- Uses sops-nix for encrypted secrets management
- Age encryption with user-managed keys
- Secrets stored in encrypted `home/secrets.yaml` (safe for VCS)
- Automatic Composer auth.json generation from encrypted secrets
- Conditional configuration ensures system works with or without secrets

### Dotfile Management
- Custom configuration files are managed through `home.file` attribute
- Includes configurations for PHP CS Fixer, EditorConfig, npm, Poetry, and Pylint
- Original shell configurations can be preserved and sourced

## Development Workflow

### Regular Configuration Changes
When modifying configurations:
1. Edit the relevant `.nix` files
2. Test changes with `nix flake check`
3. Apply changes with appropriate command:
   - Home Manager: `nix run .#homeConfigurations.jonerickson.activationPackage`
   - System: `nix build .#darwinConfigurations.jonerickson.system && sudo ./result/sw/bin/darwin-rebuild activate`
4. Commit changes to version control

### Working with Secrets
When adding or updating secrets:
1. Edit secrets: `sops home/secrets.yaml`
2. Update Nix configuration to reference new secrets
3. Apply Home Manager configuration to activate changes
4. Commit encrypted secrets file (never commit unencrypted)

### Important Notes
- The flake uses multiple nixpkgs channels (stable, unstable) for package flexibility
- Configuration is conditional - works with or without secrets
- Always test with `nix flake check` before applying changes
- Secrets are managed outside of Nix store for security