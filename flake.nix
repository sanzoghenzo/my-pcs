{
  description = "Sanzoghenzo home systems configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    deploy-rs,
    # disko,
    nixos-hardware,
    ...
  }: let
    system = "x86_64-linux";
    myPkgsOverlay = final: prev: (import ./pkgs { pkgs = prev; });
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ myPkgsOverlay ];
    };
    deployPkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        deploy-rs.overlay
        (self: super: {
          deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; };
        })
      ];
    };
  in {
    # systems configuration
    nixosConfigurations = {
      discovery = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./systems/discovery
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.sanzo = import ./home/sanzo;
            };
          }
        ];
      };
      viewscreen = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          # disko.nixosModules.disko
          ./systems/viewscreen
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.kodi = import ./home/kodi;
            };
          }
        ];
      };
    };

    # profiles to use with nix develop
    devShells."${system}".default = pkgs.mkShell {
      buildInputs = [
        pkgs.nix
        pkgs.home-manager
        pkgs.git
        pkgs.go-task
        pkgs.helix
        pkgs.deploy-rs
      ];
    };

    # deploy-rs profiles
    deploy.nodes = {
      viewscreen = {
        sshUser = "root";
        hostname = "viewscreen";
        profiles.system = {
          user = "root";
          path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.viewscreen;
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
