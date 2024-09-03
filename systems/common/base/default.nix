{ lib, username? null, hostname, ... }:
{
  imports = [
    ./boot.nix
    ./cleanup.nix
    ./locale.nix
    ./console.nix
    ./packages.nix
    ../services/tailscale.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
    firewall.enable = true;
    enableIPv6 = false;
  };

  # programs = {
  #   zsh.enable = true;
  # };

  services = {
    chrony.enable = true;
    journald.extraConfig = "SystemMaxUse=250M";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Create dirs for home-manager
  systemd.tmpfiles.rules = lib.mkIf (username != null) [ "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root" ];
}
