
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

### 2. Enable Flakes
If not already enabled, add flake support to `/etc/nix/nix.custom.conf`:
```  
experimental-features = nix-command flakes  
```  

### 3. Install Git 
Since Home Manager will manage Git, install it temporarily to clone the repository. This will only install `git` for the current shell. Once exited, `git` will no longer be in your `PATH`.
```bash
nix-shell -p git
```

### 4. Clone Repository
```bash  
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```  

## Installation

### First-time Setup
```bash
# Apply Home Manager configuration
nix run .#homeConfigurations.jonerickson.activationPackage
```  

#### 2. Apply System Configuration (Darwin):
```bash  
nix build .#darwinConfigurations.jonerickson.system
sudo ./result/sw/bin/darwin-rebuild activate
```  

**Important**: Make sure all changes are committed before building: `git add -A && git commit -m "Initial setup"`

#### 3. Setup Secrets Management (Optional)
If you need to manage secrets, follow these steps:

##### Option A: Fresh Install (Generate New Key)
1. **Generate a new age encryption key**:
```bash  
mkdir -p ~/.config/sops/ageage-keygen > ~/.config/sops/age/keys.txt
```  

2. **Get your public key and update configuration**:
```bash  
age-keygen -y ~/.config/sops/age/keys.txt
```  

3. **Update `.sops.yaml`** with your new public key (replace the existing key).

4. **Create and encrypt your secrets file**:
```bash  
# Create unencrypted secrets file  
cp home/secrets.yaml.example home/secrets.yaml  # if example exists  
# OR manually create home/secrets.yaml with your secrets  
  
# Encrypt the file  
sops -e -i home/secrets.yaml  
  
# Commit the encrypted file  
git add home/secrets.yaml .sops.yaml  
git commit -m "Add encrypted secrets"  
```  

##### Option B: Migrating from Existing Setup
1. **Copy your existing age key** from your old machine:
```bash  
mkdir -p ~/.config/sops/age
# Copy your existing keys.txt file to ~/.config/sops/age/keys.txt
```  

2. **The existing `.sops.yaml` and encrypted `home/secrets.yaml`** should already work with your key.

3. **Test decryption**:
```bash  
sops -d home/secrets.yaml
```  

#### Secrets File Structure
The `home/secrets.yaml` file should contain:
```yaml  
composer:
  whizzy-username: your-username
  whizzy-password: your-password
  filament-username: your-username
  filament-password: your-password
  spark-username: your-username
  spark-password: your-password
  github-token: your-github-token  
```  

**Note**: Do not commit an unencrypted version `home/secrets.yaml` to your VCS. You should only commit the encrypted version of your secrets.

## Subsequent Updates

### Regular User Configuration Updates
After making changes to the user configuration:
```bash  
git add -A
git commit -m "Update user configuration"
nix run .#homeConfigurations.jonerickson.activationPackage
```  

### Regular System Configuration Updates
After making changes to the system configuration:
```bash  
git add -A
git commit -m "Update system configuration"
nix build .#darwinConfigurations.jonerickson.system
sudo ./result/sw/bin/darwin-rebuild activate
```  

### Updating Secrets
To update encrypted secrets:
```bash  
# Edit secrets (will decrypt, open editor, then re-encrypt)  
sops home/secrets.yaml  
  
# Or manually decrypt, edit, and re-encrypt  
sops -d home/secrets.yaml > temp_secrets.yaml  

# Edit temp_secrets.yaml  
sops -e -i temp_secrets.yaml  
mv temp_secrets.yaml home/secrets.yaml  
  
# Commit changes  
git add home/secrets.yaml  
git commit -m "Update secrets"  
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
