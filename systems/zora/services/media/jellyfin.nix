{ ... }:
{
  services.jellyfin = {
    enable = true;
    group = "multimedia";
    openFirewall = true; # needed for DLNA
  };

  # ${services.jellyfin.configDir}/system.xml

  imports = [
    (import ../expose-service.nix {
      name = "media";
      port = 8096;
      cert = "staging";
    })
  ];
}
