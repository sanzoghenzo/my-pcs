{ config, lib, ... }:

{
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      qemu.options = [ "-vga none" "-device virtio-vga-gl" "-display gtk,gl=on" ];
    };
    users.users.root.password = "test";
    services.resolved.extraConfig = lib.mkForce "";
    networking.wg-quick.interfaces = lib.mkForce { };
  };
}
