{
  description = "Sanzoghenzo home systems configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
    deploy-rs.url = "github:serokell/deploy-rs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
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
      overlays = [
        myPkgsOverlay
        inputs.agenix.overlays.default
      ];
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
  in rec {
    # systems configuration
    nixosConfigurations = {
      discovery = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./systems/discovery
          nixos-hardware.nixosModules.dell-xps-15-9560-intel
          inputs.agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.sanzo = import ./home/sanzo;
            };
          }
        ];
        specialArgs = {
          username = "sanzo";
          hostname = "discovery";
        };
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
        specialArgs = {
          username = "kodi";
          hostname = "viewscreen";
        };
      };
    };

    vms = {
      viewscreen = nixosConfigurations.viewscreen.config.system.build.vm;
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
