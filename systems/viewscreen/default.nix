{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./graphics.nix
    # ./disk-config.nix
    ./pipewire.nix
    ./kodi.nix
    ./spotifyd.nix
    #   # ./hyperion.nix
    ../common/services/podman.nix
    ./acestream.nix
  ];

  hostname = "viewscreen";
  baseServer.enable = true;

  # virtualisation.vmVariant.virtualisation = {
  #   graphics = true;
  #   qemu.options = [
  #     "-vga none"
  #     "-device virtio-vga-gl"
  #     "-display gtk,gl=on"
  #     "-audiodev pipewire,id=audio0"
  #     "-device intel-hda"
  #     "-device hda-output,audiodev=audio0"
  #   ];
  # };
}
