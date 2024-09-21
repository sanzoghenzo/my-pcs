{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/base
    ../common/services/tailscale.nix
    ../common/root-ssh.nix
    ../common/vm.nix
    ../common/eth0-wol.nix
    ./services
  ];
}
