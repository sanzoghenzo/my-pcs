{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/kodi.nix
    ./kodi.nix
    ./acestream.nix
    # ./hyperion.nix
    ../common/base
    ../common/root-ssh.nix
    ../common/vm.nix
    ../common/eth0-wol.nix
    # ./disk-config.nix
  ];

  virtualisation.vmVariant.virtualisation = {
    graphics = true;
    qemu.options = [
      "-vga none"
      "-device virtio-vga-gl"
      "-display gtk,gl=on"
    ];
  };
}
