{
  description = "Flake-based Home Manager config for Jon Erickson's macOS";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      darwin,
      home-manager,
      nix-homebrew,
      ...
    }:
    let
      system = "x86_64-darwin";
      username = "jonerickson";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      };
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit username;
        };

        modules = [
          ./home/default.nix
          {
            home = {
              username = username;
              homeDirectory = "/Users/${username}";
              stateVersion = "24.05";
            };
          }
        ];
      };

      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        inherit system;

        specialArgs = {
          inherit username;
        };

        modules = [
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/home-manager.nix
          {
            home-manager.users.${username} = import ./home/default.nix;

            networking = {
              hostName = username;
              localHostName = username;
              computerName = "Jon's MacBook Pro";
            };

            homebrew.enable = true;
            homebrew.casks = [
              "discord"
              "google-chrome"
              "postman"
              "spotify"
              "zoom"
            ];
          }
        ];
      };
    };
}
