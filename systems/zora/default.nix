{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/services/tailscale.nix
    ../common/services/podman.nix
    ./services
    ./backup.nix
  ];

  hostname = "zora";
  baseServer.enable = true;
  mediaServer.enable = true;
  webInfra.enable = true;
  # remove once I got the dns and proxy working
  mediaServer.openPorts = true;
  monitoring.enable = false;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = lib.mkForce false;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

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
