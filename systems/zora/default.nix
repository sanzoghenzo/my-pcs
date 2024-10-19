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
    ../common/services/podman.nix
    ../common/root-ssh.nix
    ../common/vm.nix
    ../common/eth0-wol.nix
    ./services
  ];

  # enable intel hw acceleration for jellyfin
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
