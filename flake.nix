{
  description = "Flake-based Home Manager config for Jon Erickson's macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
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
      system = "aarch64-darwin";
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
              stateVersion = "25.05";
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
          ./modules/darwin/system.nix
          ./modules/darwin/networking.nix
          ./modules/darwin/homebrew.nix
          ./modules/home-manager.nix
        ];
      };
    };
}
