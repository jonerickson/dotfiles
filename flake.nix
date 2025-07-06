{
	description = "Flake-based Home Manager config for macOS";

	inputs = {
	    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
	    home-manager.url = "github:nix-community/home-manager";
	    home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-darwin";
      username = "jonerickson";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
        home = {
          username = username;
          homeDirectory = "/Users/${username}";

          stateVersion = "24.05";

          programs.zsh = {
            enable = true;
            shellAliases = {
              ll = "ls -lah";
            };
            initExtra = ''
              export ZSH_THEME="agnoster"
              export PATH="$HOME/bin:$PATH"
            '';
          };

          home.file.".zshrc".text = ''
            export ZSH_THEME="agnoster"
            alias ll="ls -lah"
            export PATH="$HOME/bin:$PATH"
          '';
        };

        programs.home-manager.enable = true;
      };
    };
}