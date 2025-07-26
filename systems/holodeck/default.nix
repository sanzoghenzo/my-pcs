{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/services/tailscale.nix
  ];

  hostname = "holodeck";
  baseServer.enable = true;
  mediaServer.enable = true;
  mediaServer.openPorts = true;
  dailyBackup.enable = true;

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
