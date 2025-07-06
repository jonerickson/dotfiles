{
  description = "Flake-based Home Manager config for macOS";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }:
    let
      system = "x86_64-darwin";
      username = "jonerickson";
      
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;  # Enable if you need proprietary software
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
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        
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
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/default.nix;
          }
        ];
      };
    };
}