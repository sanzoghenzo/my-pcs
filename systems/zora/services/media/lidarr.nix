{ ... }:
{
  services.lidarr = {
    enable = true;
    group = "multimedia";
  };

  imports = [
    (import ../expose-service.nix {
      name = "lidarr";
      port = 8686;
      cert = "staging";
    })
  ];
  # TODO: dns
  # services.lidarr.dataDir
}
