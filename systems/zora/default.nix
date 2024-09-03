{ lib, config, pkgs, hostname, ...}:
{
  imports = [ 
    ./hardware-configuration.nix
    ../common/base
    ../common/root-ssh.nix
    ../common/vm.nix
    ./services
  ];

  networking = {
    interfaces.eth0 = {
      wakeOnLan.enable = true;
    };
    nat = {
      enable = true;
      externalInterface = "eth0";
    };
    iproute2.enable = true;
  };
}
