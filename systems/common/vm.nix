{ config, lib, ... }:

{
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      graphics = lib.mkDefault false;
    };
    users.users.root.password = "test";
    services.resolved.extraConfig = lib.mkForce "";
    networking.wg-quick.interfaces = lib.mkForce { };
  };
}
