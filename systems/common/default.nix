{ inputs, lib, config, pkgs, ...}:
{
  imports = [ 
    ./boot.nix
    ./root-ssh.nix
    ./cleanup.nix
    ./vm.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
}
