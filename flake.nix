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
    agenix.inputs.darwin.follows = "";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      deploy-rs,
      # disko,
      nixos-hardware,
      agenix,
      ...
    }:
    let
      system = "x86_64-linux";
      myPkgsOverlay = final: prev: (import ./pkgs { pkgs = prev; });
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          myPkgsOverlay
          agenix.overlays.default
        ];
      };
      deployPkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          deploy-rs.overlay
          (self: super: {
            deploy-rs = {
              inherit (pkgs) deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };
      inherit
        (import ./utils.nix {
          inherit
            inputs
            system
            pkgs
            deployPkgs
            ;
        })
        mkSystem
        mkDeploy
        ;
    in
    rec {
      # systems configuration
      nixosConfigurations = {
        discovery = mkSystem [
          ./systems/discovery
          nixos-hardware.nixosModules.dell-xps-15-9560-nvidia
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.sanzo = import ./home/dev-desktop.nix;
            };
          }
        ];
        viewscreen = mkSystem [
          # disko.nixosModules.disko
          ./systems/viewscreen
          nixos-hardware.nixosModules.common-cpu-intel
        ];
        zora = mkSystem [
          ./systems/zora
          nixos-hardware.nixosModules.common-cpu-intel
        ];
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
        viewscreen = mkDeploy "viewscreen";
        zora = mkDeploy "zora";
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
