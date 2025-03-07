{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./pipewire.nix
    ./kodi.nix
    ./spotifyd.nix
    ./acestream.nix
    # ./hyperion.nix
    ../common/services/podman.nix
    # ./disk-config.nix
  ];

  hostname = "viewscreen";
  baseServer.enable = true;

  virtualisation.vmVariant.virtualisation = {
    graphics = true;
    qemu.options = [
      "-vga none"
      "-device virtio-vga-gl"
      "-display gtk,gl=on"
      "-audiodev pipewire,id=audio0"
      "-device intel-hda"
      "-device hda-output,audiodev=audio0"
    ];
  };
}
