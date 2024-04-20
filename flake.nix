{
  description = "Sanzoghenzo home systems configuration";
  nixConfig.bash-prompt = "nix-systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ 
    self, 
    nixpkgs, 
    home-manager,
    deploy-rs,
    nixgl,
    nixos-hardware,
    ... 
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    deployPkgs = import nixpkgs {
      inherit system;
      overlays = [
        nixgl.overlay
        deploy-rs.overlay
        (self: super: { 
          deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; 
        })
      ];
    };
  in {
    # systems configuration
    nixosConfigurations = {
      viewscreen = nixpkgs.lib.nixosSystem {
        system = "${system}";
        modules = [
          ./systems/viewscreen
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kodi = import ./home/kodi;
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
        # deployPkgs.nixgl.auto.nixGLDefault
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
