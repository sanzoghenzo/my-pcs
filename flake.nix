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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, deploy-rs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    deployPkgs = import nixpkgs {
      inherit system;
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
        pkgs.deploy-rs
        pkgs.helix
      ];
    };

    # deploy-rs profiles
    deploy.nodes = {
      viewscreen = {
        sshUser = "root";
        hostname = "viewscreen";
        # interactiveSudo = true;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib."${system}".activate.nixos self.nixosConfigurations.viewscreen;
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
