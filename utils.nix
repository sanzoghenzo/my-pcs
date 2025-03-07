{
  inputs,
  system,
  pkgs,
  deployPkgs,
}: {
  mkSystem = modules:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs.inputs = inputs;
      inherit system pkgs;
      modules =
        [
          ./modules
          inputs.agenix.nixosModules.default
        ]
        ++ modules;
    };

  mkDeploy = name: {
    sshUser = "sanzo";
    interactiveSudo = true;
    hostname = name;
    profiles.system = {
      user = "root";
      path = deployPkgs.deploy-rs.lib.activate.nixos inputs.self.nixosConfigurations.${name};
    };
  };
}
