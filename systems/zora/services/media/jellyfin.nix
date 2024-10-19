{ ... }:
{
  services.jellyfin = {
    enable = true;
    group = "multimedia";
    openFirewall = true; # needed for DLNA
  };

  # add hardware decoding
  users.users.jellyfin.extraGroups = [ "render" ];


  imports = [
    (import ../expose-service.nix {
      name = "media";
      port = 8096;
      cert = "staging";
    })
  ];
}
