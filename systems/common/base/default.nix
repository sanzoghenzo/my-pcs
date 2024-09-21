{
  lib,
  username ? null,
  hostname,
  ...
}:
{
  imports = [
    ./boot.nix
    ./cleanup.nix
    ./locale.nix
    ./packages.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
    enableIPv6 = lib.mkDefault false;
    firewall.enable = true;
  };

  programs = {
    thefuck.enable = true;
    # TODO: starship
    # zsh.enable = true;
  };

  services = {
    chrony.enable = true;
    journald.extraConfig = "SystemMaxUse=250M";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Create dirs for home-manager
  systemd.tmpfiles.rules = lib.mkIf (username != null) [
    "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
  ];

  system.stateVersion = "24.05";
}
