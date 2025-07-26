{
  lib,
  config,
  pkgs,
  ...
}: let
  hosts = config.hostInventory;
in {
  imports = [
    ./hardware-configuration.nix
    ../common/services/tailscale.nix
    ../common/services/podman.nix
    ./services
  ];

  hostname = "zora";
  networking = {
    useDHCP = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = hosts.zora.ipAddress;
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = hosts.modem.ipAddress;
      interface = "eth0";
    };
    nameservers = ["127.0.0.1" "1.1.1.1"];
  };
  baseServer.enable = true;
  webInfra.enable = true;
  mediaServer.enable = true;
  mediaServer.openPorts = true;
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

  dailyBackup = {
    enable = true;
    # here we add the containers data dir, the other services will add their own paths
    paths = ["/var/lib/containers/storage/volumes"];
  };
}
