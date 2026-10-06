
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
git clone https://github.com/jonerickson/dotfiles.git
cd dotfiles
```  

## Installation

#### 1. Apply Home Manager Configuration:
```bash
# Apply Home Manager configuration
nix run .#homeConfigurations.jonerickson.activationPackage
```  

#### 2. Apply System Configuration (Darwin):
```bash  
# Make sure command line tools have been installed first
xcode-select --install

nix build .#darwinConfigurations.jonerickson.system
sudo ./result/sw/bin/darwin-rebuild activate
```  

**Important**: Make sure all changes are committed before building: `git add -A && git commit -m "Initial setup"`

#### 3. Setup Secrets Management (Optional)
If you need to manage secrets, follow these steps:

##### Option A: Fresh Install (Generate New Key)
1. **Generate a new age encryption key**:
```bash  
mkdir -p ~/.config/sops/age
age-keygen > ~/.config/sops/age/keys.txt
```  

2. **Get your public key and update configuration**:
```bash  
age-keygen -y ~/.config/sops/age/keys.txt
```  

3. **Update `.sops.yaml` with your new public key (replace the existing key)**

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
1. **Copy your existing age key from your old machine**:
```bash  
mkdir -p ~/.config/sops/age
# Copy your existing keys.txt file to ~/.config/sops/age/keys.txt
```  

2. **The existing `.sops.yaml` and encrypted `home/secrets.yaml` should already work with your key**

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
- **PHP**: PHP 8.4 and Composer via Nix, with global packages installed on activation — Laravel installer, Pest, PHPStan, Pint, PHP CS Fixer, PHP_CodeSniffer, Statamic CLI, composer-normalize, WPCS
- **Node.js**: Bun via Nix. Node itself is managed by `nvm` outside Nix; activation installs the global packages `happy-coder`, `opencode-ai`, and `workos` against the current `nvm` default
- **Python**: poetry and pyenv (the interpreter comes from pyenv, not Nix), with global packages pip-installed into the pyenv global version on activation — openpyxl
- **Ruby**: Ruby 3.3, CocoaPods

### Databases & Storage
- **Databases**: MySQL 8.4, Redis, SQLite via Nix; PostgreSQL 18 via Homebrew
- **GUI Tools**: DBeaver, TablePlus

### IDEs & Editors
- **IDEs**: PhpStorm, PyCharm, Sublime Text, nano, vim
- **Editor Configs**: EditorConfig, PHP CS Fixer, Pylint configuration

### Development Infrastructure
- **Containers**: Docker CLI and Docker Compose via Nix, Docker Desktop via Homebrew
- **Cloud & Infra**: Google Cloud SDK (with `cloud-sql-proxy` and `gke-gcloud-auth-plugin`), AWS CLI, `aws-iam-authenticator`, `eksctl`, DigitalOcean `doctl`, Heroku CLI, MinIO client, OpenTofu, Terraform, Pomerium CLI, Stripe CLI
- **Kubernetes**: `kubectl` via Nix, `kubernetes-cli` and Helm via Homebrew, Headlamp for a GUI
- **Build Tools**: GNU Make, CMake, pkg-config
- **Version Control**: Git with LFS, GitHub CLI, git-filter-repo
- **Web Tools**: curl, wget, HTTPie, Postman, mkcert, ngrok, chromedriver

### PHP Extensions (Homebrew)
`grpc@8.5`, `protobuf@8.5`, and `pcov@8.5` from the `shivammathur/extensions` tap, built against PHP 8.5. These are consumed by Laravel Herd rather than by the Nix PHP — see [Homebrew](#homebrew) for how they are wired up and what breaks them.

### CLI Utilities
- **Search & Navigation**: ripgrep, fd, fzf, bat, tree
- **System**: htop, jq, yq
- **Archives**: unzip, p7zip
- **Media**: ImageMagick, FFmpeg
- **Documents**: qpdf
- **Network**: OpenSSH, rsync

### Shell & Environment
- **Shell**: Zsh with Oh My Zsh, syntax highlighting, autosuggestions
- **Theme & Plugins**: Robbyrussell theme; git, brew, macos, docker, docker-compose, npm, yarn, composer, laravel, symfony, poetry plugins
- **Package Management**: Nix with flakes support, nixfmt for code formatting
- **Secrets**: sops and age

### Claude Code
`home/programs/claude.nix` declares the marketplaces and plugins installed on activation, including `laravel/claude-code` and a set of official plugins (context7, laravel-boost, code-review, feature-dev, sentry, atlassian, and others).

### macOS Applications (Homebrew Casks)
- **Productivity**: 1Password, 1Password CLI, Raycast, Slack, Discord, Spotify
- **Development**: Docker Desktop, Google Chrome, PhpStorm, PyCharm, Postman, Sublime Text, TablePlus, Headlamp
- **Terminal**: Ghostty

## Homebrew

Homebrew is installed and owned by [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) (`modules/darwin/system.nix`), while the package list is declared with nix-darwin's `homebrew` options (`modules/darwin/homebrew.nix`).

### The Version Coupling

The `brew` executable is **not** a nixpkgs package. It is built from the `brew-src` flake input that `nix-homebrew` carries, so the Homebrew version is pinned by `flake.lock` and only moves when the flake is updated.

Taps are mutable and update themselves on every activation (`onActivation.autoUpdate = true`). This creates the one failure mode worth knowing about: **taps track upstream while `brew` stays pinned**, so a tap that adopts a newer formula DSL breaks against an older pinned `brew`:

```
Error: shivammathur/php/php: undefined method 'compatibility_version'
```

`compatibility_version` is a formula DSL method, so the fix is to move `brew` forward — never to pin the tap back, since auto-update undoes that on the next activation.

`nixpkgs`, `darwin`, and `nix-homebrew` must move **together**. Advancing one alone fails in both directions:

| Combination                        | Failure                                           |
|------------------------------------|---------------------------------------------------|
| New `nix-homebrew` + old `nixpkgs` | `attribute 'ruby_4_0' missing`                    |
| New `nixpkgs` + old `darwin`       | `nixos-render-docs: --toc-depth has been removed` |

Run `nix flake update` with no arguments so the whole set advances at once. Updating a single input is unreliable here — `nix flake update nix-homebrew` also moves `nixpkgs`, while reporting only the input you named.

### Updating

```bash
nix flake update
nix build .#darwinConfigurations.jonerickson.system
sudo ./result/sw/bin/darwin-rebuild activate
```

`nix build` is free to retry and changes nothing, so build first and only activate once it succeeds. `flake.lock` is the only file these commands change, so `git checkout flake.lock` reverts an update that goes wrong.

Activation is more destructive than a build: `onActivation.upgrade = true` upgrades every declared brew and cask, and `cleanup = "zap"` removes anything Homebrew has that `homebrew.nix` does not declare.

### PHP Extensions and Laravel Herd

The `*@8.5` extension formulae install into `/opt/homebrew/opt/<name>@8.5/<name>.so`. Herd loads them through an ini file it does not own:

```
~/Library/Application Support/Herd/config/php/85/zz-cake.ini
```

That file is generated by Leasecake's `cake onboard` and carries a `; Managed by cake — do not edit` header, so changes to it are overwritten. It writes an `extension=` line per extension without checking that the path exists, so an extension declared in `homebrew.nix` but never actually installed surfaces later as a PHP startup warning:

```
Warning: PHP Startup: Unable to load dynamic library '/opt/homebrew/opt/pcov@8.5/pcov.so'
```

The ini file is correct in that case and the extension is simply missing. Confirm with `ls /opt/homebrew/opt/pcov@8.5`, then fix it by activating so the declaration in `homebrew.nix` installs — not by editing the ini.

### Tap Trust

Homebrew requires non-official taps to be trusted before it will load their formulae or casks (`HOMEBREW_REQUIRE_TAP_TRUST`, on by default). An untrusted tap **raises** rather than prompting, so activation fails outright:

```
Error: Refusing to load formula pomerium/tap/pomerium-cli from untrusted tap pomerium/tap.
```

Official taps (`homebrew/core`, `homebrew/cask`) are exempt. Every other tap in `homebrew.nix` needs an entry in the trust store, and `shivammathur/php` needs one too even though nothing declares it directly — it is the dependency of the `*@8.5` extension formulae.

The `preActivation` script in `modules/darwin/homebrew.nix` writes that store, keyed off the same `trustedTaps` list. It writes a file rather than shelling out to `brew trust` so it does not depend on the brew currently installed having the `trust` subcommand.

#### Why It Writes Four Paths

Brew resolves the trust store from two environment values, and activation changes both:

```
result/activate: sudo --preserve-env=PATH --user=jonerickson --set-home env brew bundle
```

- Only `PATH` survives, so `XDG_CONFIG_HOME` is unset and the config home falls back from `~/.config/homebrew` to `~/.homebrew`.
- `sudo` from root leaves `SUDO_USER=root`, so brew resolves that fallback against `/var/root` rather than the user's home.

An interactive shell has neither property — `xdg.enable = true` exports `XDG_CONFIG_HOME` — so **`brew` succeeding in your terminal proves nothing about activation**. Verify the two contexts separately:

```bash
# The user's view: passes whenever ~/.config/homebrew/trust.json is seeded
brew info pomerium/tap/pomerium-cli

# What brew actually reads
brew trust --json=v1
```

Seeding all four combinations of (root, user) x (`.homebrew`, `.config/homebrew`) covers whichever pair brew resolves to, at the cost of three redundant files.

## Maintenance

### Update Dependencies
```bash
nix flake update
```

Always follow with a build and activation — see [Updating](#updating).

### Code Formatting
```bash
nixfmt ./**/*.nix
```

## Structure

- `flake.nix` — Inputs and outputs; defines `homeConfigurations.jonerickson` and `darwinConfigurations.jonerickson`
- `flake.lock` — Pins every input, including the Homebrew version via `brew-src`
- `home/default.nix` — Home Manager entrypoint; imports everything under `home/programs/`
- `home/programs/` — Per-tool user configuration (claude, composer, dev, git, npm, python, ssh, zsh)
- `home/dotfiles/` — Literal dotfiles sourced into `$HOME` (`herd.zsh`)
- `home/secrets.yaml` — sops-encrypted secrets; `home/secrets.yaml.example` shows the shape
- `modules/home-manager.nix` — Wires Home Manager into the darwin configuration
- `modules/darwin/` — System-level modules: `system.nix` (macOS defaults, nix-homebrew), `homebrew.nix` (taps, brews, casks), `networking.nix` (application firewall)
