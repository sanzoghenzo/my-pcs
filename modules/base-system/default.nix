{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config;
in
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./cleanup.nix
    ./packages.nix
  ];

  options = {
    hostname = lib.mkOption {
      type = lib.types.str;
      example = "computer";
      description = "Name of the host machine.";
    };
  };

  config = {
    nix.settings.experimental-features = "nix-command flakes";

    networking = {
      hostName = cfg.hostname;
      useDHCP = lib.mkDefault true;
      enableIPv6 = lib.mkDefault false;
      firewall.enable = true;
    };

    services = {
      chrony.enable = true;
      journald.extraConfig = "SystemMaxUse=250M";
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    system.stateVersion = lib.mkDefault "24.05";
  };
}
